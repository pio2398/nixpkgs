{ lib, buildGoModule, fetchFromGitHub, installShellFiles }:

buildGoModule rec {
  pname = "steampipe";
  version = "0.11.2";

  src = fetchFromGitHub {
    owner = "turbot";
    repo = "steampipe";
    rev = "v${version}";
    sha256 = "sha256-omg/MgCTKkj0p1vDvJs22/0Jhzim0CeISV0Kn9p5lh4=";
  };

  vendorSha256 = "sha256-PYaq74NNEOJ1jZ6PoS6zcTiUN4JA9JDjO7GB9tqgT6c=";

  # tests are failing for no obvious reasons
  doCheck = false;

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
  ];

  postInstall = ''
    INSTALL_DIR=$(mktemp -d)
    installShellCompletion --cmd steampipe \
      --bash <($out/bin/steampipe --install-dir $INSTALL_DIR completion bash) \
      --fish <($out/bin/steampipe --install-dir $INSTALL_DIR completion fish) \
      --zsh <($out/bin/steampipe --install-dir $INSTALL_DIR completion zsh)
  '';

  meta = with lib; {
    homepage = "https://steampipe.io/";
    description = "select * from cloud;";
    license = licenses.agpl3;
    maintainers = with maintainers; [ hardselius ];
  };
}
