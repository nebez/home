# Nixify the current directory
if [ ! -e ./.envrc ]; then
    echo "use nix" > .envrc
    direnv allow
fi
if [[ ! -e shell.nix ]] && [[ ! -e default.nix ]]; then
    # Make a default shell.nix and then pop open an editor
    niv init --latest
    cat > shell.nix <<'EOF'
let
    sources = import ./nix/sources.nix;
    pkgs = import sources.nixpkgs {};
in
pkgs.mkShell {
    buildInputs = [
    ];
}
EOF
    nano shell.nix
fi
