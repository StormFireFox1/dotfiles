let
  tempBullshitMachineUser = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINPgMul7XW0LoM3ADHGLu/Tkn+XQGKRD+gtcHxiW3IAn";
  stormPrismSecretiveKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGOW5gIaGw2Y8pzOM9C3G9frgqMf2SfleeUAPeIP0/6S";

  bullshitMachine = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEM4ocxU0ch5PSxPEMRmvUSfFZtclgburTjrEeCEYCFI";
  stormPrism = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIk+BK0oDAYn3KI8Q62kU1IgPXTUBsRHKUUz/TC4zBxz";

  users = [
    tempBullshitMachineUser
    stormPrismSecretiveKey
  ];
in
{
  "StormDriveSmbKey.age".publicKeys = users ++ [ bullshitMachine ];
  "BorgBackupKey.age".publicKeys = users ++ [
    bullshitMachine
    stormPrism
  ];
}
