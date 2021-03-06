class Mame < Formula
  desc "Multiple Arcade Machine Emulator"
  homepage "http://mamedev.org/"
  url "https://github.com/mamedev/mame/archive/mame0176.tar.gz"
  version "0.176"
  sha256 "e8837ae9c21ac6ca289c0214747a6d7ff7cc4683b9426377f42cda318fddcb25"
  revision 1
  head "https://github.com/mamedev/mame.git"

  bottle do
    cellar :any
    sha256 "601e039502a807abdd50d9a9bbd7748ac4d8aada02fc91aa6367aea67b74b11e" => :el_capitan
    sha256 "4f61e10147a97d803c3e41652914163c3d0e0565a5c940f329d8a29fe7053b66" => :yosemite
    sha256 "3a9a3b1a59952d88331aa6059ec419d6451e9ef333a63bd6f6fff5da2fd6dca8" => :mavericks
  end

  depends_on :python => :build if MacOS.version <= :snow_leopard
  depends_on "pkg-config" => :build
  depends_on "sdl2"
  depends_on "jpeg"
  depends_on "flac"
  depends_on "sqlite"
  depends_on "portmidi"
  depends_on "portaudio"
  depends_on "libuv"

  # Needs GCC 4.9 or newer
  fails_with :gcc_4_0
  fails_with :gcc
  ("4.3".."4.8").each do |n|
    fails_with :gcc => n
  end

  def install
    inreplace "scripts/src/main.lua", /(targetsuffix) "\w+"/, '\1 ""'
    inreplace "scripts/src/osd/sdl.lua", "--static", ""
    system "make", "PTR64=#{MacOS.prefer_64_bit? ? 1 : 0}", # for old Macs
                   "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=", # brewed version not picked up
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_JPEG=1",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_LUA=", # lua53 not available yet
                   "USE_SYSTEM_LIB_SQLITE3=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_PORTAUDIO=1",
                   "USE_SYSTEM_LIB_UV=1"
    bin.install "mame"
    man6.install "docs/man/mame.6"
    doc.install Dir["docs/*.txt", "docs/*.md", "docs/LICENSE"]
    pkgshare.install %w[artwork bgfx hash keymaps plugins samples]
    (pkgshare/"shader").install Dir["src/osd/modules/opengl/shader/*.[vf]sh"]
  end

  test do
    assert shell_output("#{bin}/mame -help").start_with? "MAME v#{version}"
    system "#{bin}/mame", "-validate"
  end
end
