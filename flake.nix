{
  description = "Personal Nix templates";

  outputs = { self }: {
    templates = {
      cpp = {
        path = ./cpp;
        description = "C++ template with Meson";
      };
      python = {
        path = ./python;
        description = "Python template with poetry2nix";
      };
    };
  };
}
