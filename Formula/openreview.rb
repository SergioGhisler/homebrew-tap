class Openreview < Formula
  desc "Local web app for reviewing project changes"
  homepage "https://github.com/SergioGhisler/openreview"
  url "https://github.com/SergioGhisler/openreview/archive/refs/tags/v0.0.1.tar.gz"
  sha256 "424907ac50db78c42ffa5f064567bedd42ef1d8163747e4817c48f47eaa496db"
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
