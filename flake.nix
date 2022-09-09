{
  description = "";

  outputs = { self }: {
    templates = {
      python = {
        path = ./python;
        description = "Python template with poetry2nix";
      };
    };
  };
}
