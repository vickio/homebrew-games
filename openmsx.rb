class Openmsx < Formula
  desc "MSX emulator"
  homepage "http://openmsx.org/"
  url "https://github.com/openMSX/openMSX/releases/download/RELEASE_0_13_0/openmsx-0.13.0.tar.gz"
  sha256 "41e37c938be6fc9f90659f8808418133601a85475058725d3e0dccf2902e62cb"
  head "https://github.com/openMSX/openMSX.git"

  bottle do
    cellar :any
    sha256 "9f5349827e8715ec2c03fb12694632e7bd54790773d81454b4f121008d5bd12c" => :el_capitan
    sha256 "961b45cb835fc1dedf110b0363df650815c4efc09e0e9593eba22d405084d205" => :yosemite
    sha256 "bb5f38611612ca55da2e83917cc43c3b05be38b13ba7fce647106bc716fcb74d" => :mavericks
  end

  option "without-opengl", "Disable OpenGL post-processing renderer"
  option "with-laserdisc", "Enable Laserdisc support"

  depends_on "sdl"
  depends_on "sdl_ttf"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "glew" if build.with? "opengl"

  if build.with? "laserdisc"
    depends_on "libogg"
    depends_on "libvorbis"
    depends_on "theora"
  end

  def install
    inreplace "build/custom.mk", "/opt/openMSX", prefix
    # Help finding Tcl
    inreplace "build/libraries.py", /\((distroRoot), \)/, "(\\1, '/usr', '#{MacOS.sdk_path}/usr')"
    system "./configure"
    system "make"
    prefix.install Dir["derived/**/openMSX.app"]
    bin.write_exec_script "#{prefix}/openMSX.app/Contents/MacOS/openmsx"
  end

  test do
    system "#{bin}/openmsx", "-testconfig"
  end
end
