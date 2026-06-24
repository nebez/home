# Nixify the current directory
write_envrc() {
    cat > .envrc <<'EOF'
watch_file shell.nix default.nix nix/sources.nix nix/sources.json
use nix
EOF
}

if [[ ! -e ./.envrc ]]; then
    write_envrc
    direnv allow
elif [[ "$(< ./.envrc)" == "use nix" ]]; then
    write_envrc
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
