{ lib, stdenv, pkgs, rustPlatform, fetchFromGitHub }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-leptos";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "leptos-rs";
    repo = pname;
    rev = version;
    sha256 = "sha256-Z7JRTsB3krXAKHbdezaTjR6mUQ07+e4pYtpaMLuoR8I=";
  };

  cargoSha256 = "sha256-MqEErweIHHF8w7WANfh8OpzvS774aIfcfkEOwEofSqw=";

  buildInputs = with pkgs; [
    # Add additional build inputs here
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    pkgs.darwin.apple_sdk.frameworks.CoreServices
    pkgs.darwin.apple_sdk.frameworks.Security
  ];

  nativeBuildInputs = with pkgs; [
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    pkg-config
    openssl
  ];

  doCheck = false;

  meta = with lib; {
    description = "Build tool for Leptos (Rust)";
    homepage = "https://github.com/leptos-rs/cargo-leptos";
    license = licenses.mit;
    maintainers = [ maintainers.rayandrew ];
  };
}
