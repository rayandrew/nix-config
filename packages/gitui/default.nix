{ lib
, stdenv
, rustPlatform
, fetchFromGitHub
, libiconv
, openssl
, pkg-config
, xclip
, darwin
}:

rustPlatform.buildRustPackage rec {
  pname = "gitui";
  version = "0.22.1";

  src = fetchFromGitHub {
    owner = "extrawurst";
    repo = pname;
    rev = "63f230f0d1de5b06b325b11924eb41f6120b30da";
    sha256 = "sha256-WquGyQVbNpBplvp2QLVI9uCcN/4xrwYF7V58AoHK8RM=";
  };

  cargoSha256 = "sha256-hyWRw9GcdYO2sx9nqV+mCcFzZ5LWe6kn5I7YWTsq+d0=";

  patches = [ ./gpg-sign.patch ];

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ]
    ++ lib.optional stdenv.isLinux xclip
    ++ lib.optionals stdenv.isDarwin [
    libiconv
    darwin.apple_sdk.frameworks.Security
    darwin.apple_sdk.frameworks.AppKit
  ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;

  # The cargo config overrides linkers for some targets, breaking the build
  # on e.g. `aarch64-linux`. These overrides are not required in the Nix
  # environment: delete them.
  postPatch = "rm .cargo/config";

  meta = with lib; {
    description = "Blazing fast terminal-ui for Git written in Rust";
    homepage = "https://github.com/extrawurst/gitui";
    license = licenses.mit;
    maintainers = with maintainers; [ Br1ght0ne yanganto ];
  };
}
