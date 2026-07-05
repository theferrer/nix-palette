{
  lib,
  pkgs,
  canvas,
}:
let
  inherit (lib)
    attrNames
    attrValues
    all
    elem
    filter
    concatMap
    unique
    ;

  catalog = import ../catalog { inherit pkgs lib; };
  spec = canvas.lib.spec.capabilities;

  fullCatalog = catalog // {
    capabilities = spec;
  };
  inherit (canvas.lib) resolve;

  inherit (catalog) software wants looks;
  names = attrNames software;

  providersOf = cap: filter (n: elem cap (software.${n}.provides or [ ])) names;
  isDefined = n: software ? ${n};

  lookNames = attrNames looks;
  wantNames = attrNames wants;

  allWantCapabilities = unique (concatMap (w: wants.${w}.capabilities or [ ]) wantNames);
  allProvides = unique (concatMap (n: software.${n}.provides or [ ]) names);

  noFailing = result: filter (a: !a.assertion) result.assertions == [ ];

  capsOf =
    wName: (wants.${wName}.capabilities or [ ]) ++ concatMap capsOf (wants.${wName}.includes or [ ]);

  compatibleWants = l: filter (wn: all (c: (looks.${l}.use or { }) ? ${c}) (capsOf wn)) wantNames;

  resolveLook =
    l:
    resolve {
      catalog = fullCatalog;
      look = l;
      wants = compatibleWants l;
    };
in
{
  testPackagesAreDerivations = {
    expr = all (
      n:
      let
        p = software.${n}.package or null;
      in
      p == null || lib.isDerivation p
    ) names;
    expected = true;
  };

  testWantSoftwareDefined = {
    expr = all (w: all isDefined (wants.${w}.software or [ ])) wantNames;
    expected = true;
  };

  testWantIncludesDefined = {
    expr = all (w: all (i: wants ? ${i}) (wants.${w}.includes or [ ])) wantNames;
    expected = true;
  };

  testWantCapabilitiesInSpec = {
    expr = filter (cap: !(spec ? ${cap})) allWantCapabilities;
    expected = [ ];
  };

  testProvidesInSpec = {
    expr = filter (cap: !(spec ? ${cap})) allProvides;
    expected = [ ];
  };

  testWantCapabilitiesHaveProvider = {
    expr = all (cap: providersOf cap != [ ]) allWantCapabilities;
    expected = true;
  };

  testLookUseDefined = {
    expr = all (l: all isDefined (attrValues (looks.${l}.use or { }))) lookNames;
    expected = true;
  };

  testLookUseProvidesCapability = {
    expr = all (
      l:
      let
        u = looks.${l}.use or { };
      in
      all (cap: elem cap (software.${u.${cap}}.provides or [ ])) (attrNames u)
    ) lookNames;
    expected = true;
  };

  testHomeModulesExist = {
    expr = all (
      n:
      let
        h = software.${n}.homeModule or null;
      in
      h == null || builtins.pathExists h
    ) names;
    expected = true;
  };

  testEveryLookResolvesClean = {
    expr = filter (l: !noFailing (resolveLook l)) lookNames;
    expected = [ ];
  };

  testLookProtocolMatchesDesktopEntry = {
    expr = all (
      l:
      let
        desktop = looks.${l}.use.desktop or null;
      in
      desktop == null || (resolveLook l).sessionProtocol == software.${desktop}.sessionProtocol
    ) lookNames;
    expected = true;
  };

  testLookAdjudicationsResolve = {
    expr = all (
      l:
      let
        resolved = resolveLook l;
        adjudicatedAndRequired = filter (cap: resolved.capabilityMap ? ${cap}) (
          attrNames (looks.${l}.use or { })
        );
      in
      all (cap: resolved.capabilityMap.${cap} == looks.${l}.use.${cap}) adjudicatedAndRequired
    ) lookNames;
    expected = true;
  };
}
