requires "CPAN" => "1.93";
requires "CPAN::HandleConfig" => "0";
requires "CPAN::Reporter::History" => "1.1702";
requires "CPAN::Tarzip" => "0";
requires "Carp" => "0";
requires "Compress::Zlib" => "1.2";
requires "Exporter" => "0";
requires "ExtUtils::MakeMaker" => "6.46";
requires "Fcntl" => "0";
requires "File::Basename" => "0";
requires "File::Spec" => "3.27";
requires "File::Temp" => "0.20";
requires "Module::Build" => "0.30";
requires "Probe::Perl" => "0.01";
requires "Term::Title" => "0.01";
requires "Test::Reporter" => "1.58";
requires "perl" => "5.006";
requires "strict" => "0";
requires "warnings" => "0";

on 'test' => sub {
  requires "CPAN::Checksums" => "0";
  requires "Cwd" => "3.27";
  requires "ExtUtils::MakeMaker" => "6.46";
  requires "File::Find" => "0";
  requires "File::Path" => "0";
  requires "File::Spec::Functions" => "0";
  requires "IO::CaptureOutput" => "1.06";
  requires "IO::File" => "0";
  requires "List::Util" => "0";
  requires "Test::More" => "0.62";
  requires "vars" => "0";
  requires "version" => "0";
};

on 'test' => sub {
  recommends "CPAN::Meta" => "0";
  recommends "CPAN::Meta::Requirements" => "2.120900";
};

on 'configure' => sub {
  requires "ExtUtils::MakeMaker" => "6.17";
};

on 'develop' => sub {
  requires "Dist::Zilla" => "5.013";
  requires "Dist::Zilla::Plugin::Encoding" => "0";
  requires "Dist::Zilla::Plugin::Prereqs" => "0";
  requires "Dist::Zilla::Plugin::RemovePrereqs" => "0";
  requires "Dist::Zilla::PluginBundle::DAGOLDEN" => "0.060";
  requires "File::Spec" => "0";
  requires "File::Temp" => "0";
  requires "IO::Handle" => "0";
  requires "IPC::Open3" => "0";
  requires "Pod::Coverage::TrustPod" => "0";
  requires "Test::CPAN::Meta" => "0";
  requires "Test::More" => "0";
  requires "Test::Pod" => "1.41";
  requires "Test::Pod::Coverage" => "1.08";
};
