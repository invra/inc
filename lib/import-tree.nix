let
  callable =
    let
      compose =
        g: f: x:
        g (f x);
      and =
        g: f: x:
        f x && g x;
      andNot = g: and (x: !(g x));

      initial = {
        api = { };
        mapf = i: i;
        filterf = _: true;
        paths = [ ];

        __functor =
          config: update:
          let
            updated = update config;
            current = config update;
            boundAPI = builtins.mapAttrs (_: g: g current) updated.api;
            accAttr = k: f: config (c: update c // { ${k} = f (update c).${k}; });
            mergeAttrs = a: config (c: update c // a);
          in
          boundAPI
          // {
            __config = updated;
            __functor =
              self: arg:
              let
                inModuleEval = builtins.isAttrs arg && arg ? options;
                isPathLike = x: builtins.isPath x || builtins.isString x || (builtins.isAttrs x && x ? outPath);

                perform =
                  if updated.pipef or null == null then
                    {
                      imports = [
                        (
                          { lib, ... }:
                          {
                            imports = leaves lib arg;
                          }
                        )
                      ];
                    }
                  else if updated.lib or null == null then
                    throw "You need to call withLib before trying to read the tree."
                  else
                    updated.pipef (leaves updated.lib arg);

                leaves =
                  lib: root:
                  let
                    isDir = x: isPathLike x && builtins.readFileType (toString x) == "directory";
                    listFiles =
                      x:
                      if builtins.isAttrs x && x ? __config.__functor then
                        (x.withLib lib).files
                      else if isPathLike x then
                        lib.filesystem.listFilesRecursive x
                      else
                        [ x ];

                    nixFilter = and (and (x: !(lib.hasInfix "/_" x)) (lib.hasSuffix ".nix")) (
                      x: !lib.hasSuffix ".zon.nix" x
                    );
                    initf = updated.initf or nixFilter;
                    pathFilter = compose (and updated.filterf initf) toString;
                    otherFilter = and updated.filterf (updated.initf or (_: true));

                    mkRel =
                      file:
                      let
                        roots = builtins.filter isDir (
                          lib.lists.flatten [
                            updated.paths
                            root
                          ]
                        );
                        s = toString file;
                        matched = lib.lists.findFirst (r: lib.hasPrefix r s) null (map toString roots);
                      in
                      if matched != null then lib.removePrefix matched s else s;

                    filter = x: if isPathLike x then pathFilter (mkRel x) else otherFilter x;
                  in
                  lib.pipe
                    [ updated.paths root ]
                    [
                      lib.lists.flatten
                      (map listFiles)
                      lib.lists.flatten
                      (builtins.filter filter)
                      (map updated.mapf)
                    ];
              in
              if inModuleEval then [ ] else perform;

            filter = f: accAttr "filterf" (and f);
            filterNot = f: accAttr "filterf" (andNot f);
            match = re: accAttr "filterf" (and (p: builtins.match re p != null));
            matchNot = re: accAttr "filterf" (andNot (p: builtins.match re p != null));
            map = f: accAttr "mapf" (compose f);
            addPath = p: accAttr "paths" (ps: ps ++ [ p ]);
            addAPI = a: accAttr "api" (existing: existing // a);
            withLib = lib: mergeAttrs { inherit lib; };
            initFilter = initf: mergeAttrs { inherit initf; };
            pipeTo = pipef: mergeAttrs { inherit pipef; };
            leaves = mergeAttrs { pipef = i: i; };
            result = current [ ];
            files = current.leaves.result;
            new = callable;
          };
      };
    in
    initial (c: c);
in
callable
