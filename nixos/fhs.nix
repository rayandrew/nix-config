{ lib, ... }:

{
  # Please use this module with extra cautions!!
  # This will make NixOS seamlessly supporting FHS

  # Thanks @volth
  # https://discourse.nixos.org/t/runtime-alternative-to-patchelf-set-interpreter/3539/5
  system.activationScripts.ldso = lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64                                                                
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp   
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace 
  '';
}
