let
  bullshitMachine = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINPgMul7XW0LoM3ADHGLu/Tkn+XQGKRD+gtcHxiW3IAn";
  stormPrism = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGOW5gIaGw2Y8pzOM9C3G9frgqMf2SfleeUAPeIP0/6S";
  users = [
    bullshitMachine
    stormPrism
  ];
in
{
  "StormDriveSmbKey.age".publicKeys = users;
}
