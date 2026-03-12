{ 
    lib,
    fetchFromGitHub,
    stdenv,
    perl,
    cmake,

    boost,
    asciidoc,
    flex,
    bison,
    fmt
}:
stdenv.mkDerivation (finalAttrs: 
let 
    cmakeOpt = name: val: "-D${name}=${toString val}";
in
{
    pname = "pajeng";
    system = "x86_64-linux";
    version = "1.3.10";

    src = ./.;

    nativeBuildInputs = [
        perl
        cmake # adding cmake as a buildinput does everything else automatically
        
        boost
        asciidoc
        flex
        bison
        fmt
    ];

    buildInputs = [ boost fmt ];
    # poti's cmake version is less then 3.5, so i need to tell it do it anyway.
    cmakeFlags = [ 
    	# "-DCMAKE_POLICY_VERSION_MINIMUM=3.5" 
        # Tells CMake to use the final installation RPATH even during the build phase
        "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON"
        # Prevents CMake from adding the build directory to the RPATH
        "-DCMAKE_SKIP_BUILD_RPATH=OFF" 
        # Ensure the install RPATH is actually set to the Nix store lib path
        "-DCMAKE_INSTALL_RPATH=${placeholder "out"}/lib"
        "-DCMAKE_BUILD_TYPE=Release"
        (cmakeOpt "PAJE_DOC" "OFF")
        (cmakeOpt "PAJE_LIBRARY" "ON")
        (cmakeOpt "PAJE_TOOLS" "ON")
        (cmakeOpt "PAJE_USE_FMT" "ON")
        (cmakeOpt "STATIC_LINKING" "OFF")
    ];

    # esse aqui foi dica do amiguinho
    # não entendi porque funciona exatamente
    # segundo ele, no check a lib não está ainda no path final na store
    # devido as flags passadas ao cmake
    # então fazemos essa inserção manual para que os testes funcionem
    # TODO: validar que deu certo
    preCheck = ''
        export LD_LIBRARY_PATH=$PWD/src/libpaje:$LD_LIBRARY_PATH
    '';

    doCheck = true;
})
