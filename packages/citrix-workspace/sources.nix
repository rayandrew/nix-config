{ stdenv, lib }:

let
  mkVersionInfo = _: { major, minor, patch, x64hash, x86hash, x64suffix, x86suffix, homepage }:
    {
      inherit homepage;
      version = "${major}.${minor}.${patch}.${if stdenv.is64bit then x64suffix else x86suffix}";
      prefix = "linuxx${if stdenv.is64bit then "64" else "86"}";
      hash = if stdenv.is64bit then x64hash else x86hash;
    };

  # Attribute-set with all actively supported versions of the Citrix workspace app
  # for Linux.
  #
  # The latest versions can be found at https://www.citrix.com/downloads/workspace-app/linux/
  supportedVersions = lib.mapAttrs mkVersionInfo {

    "23.02.0" = {
      major = "23";
      minor = "2";
      patch = "0";
      x64hash = "d0030a4782ba4b2628139635a12a7de044a4eb36906ef1eadb05b6ea77c1a7bc";
      x86hash = "39228fc8dd69adca4e56991c1ebc0832fec183c3ab5abd2d65c66b39b634391b";
      x64suffix = "10";
      x86suffix = "10";
      homepage = "https://www.citrix.com/downloads/workspace-app/legacy-workspace-app-for-linux/workspace-app-for-linux-latest6.html";
    };

    "23.05.0" = {
      major = "23";
      minor = "5";
      patch = "0";
      x64hash = "3a81e141d641b3ed837dbbee7958ef01a760a06a2bb5a432065923682c9a7303";
      x86hash = "e2b0be7c226bc43813df25544bdf4c907c2cda55fc4ed58ea7fa02d5120d8b51";
      x64suffix = "58";
      x86suffix = "58";
      homepage = "https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html";
    };

  };

  # Retain attribute-names for abandoned versions of Citrix workspace to
  # provide a meaningful error-message if it's attempted to use such an old one.
  #
  # The lifespans of Citrix products can be found here:
  # https://www.citrix.com/support/product-lifecycle/milestones/receiver.html
  unsupportedVersions = [ ];
in
{
  inherit supportedVersions unsupportedVersions;
}
