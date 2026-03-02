class Openreview < Formula
  desc "Local web app for reviewing project changes"
  homepage "https://github.com/SergioGhisler/openreview"
  url "https://github.com/SergioGhisler/openreview/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "4115bf088409f58a04933e24dec3511a18155ebb56ac5ab48c5e15f504cc3a97"
  license "MIT"

  depends_on "node"

  def install
    libexec.install Dir["*"]
    cd libexec do
      system "npm", "install", "--omit=dev"
    end

    (bin/"openreview").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/server.js" "$@"
    EOS
  end

  def post_install
    (var/"openreview").mkpath
    (var/"log").mkpath
  end

  service do
    run [opt_bin/"openreview"]
    keep_alive true
    working_dir var/"openreview"
    environment_variables PORT: "5050"
    log_path var/"log/openreview.log"
    error_log_path var/"log/openreview.err.log"
  end

  test do
    assert_predicate bin/"openreview", :exist?
    assert_predicate libexec/"server.js", :exist?
  end
end
