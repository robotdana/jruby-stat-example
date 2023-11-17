require 'tmpdir'

PARENT_DIR = Dir.mktmpdir
REAL_FILE = File.join(PARENT_DIR, 'real_file')
File.write(REAL_FILE, '')
REAL_DIRECTORY = File.join(PARENT_DIR, 'real_directory')
Dir.mkdir(REAL_DIRECTORY)
SYMLINK_TO_FILE = File.join(PARENT_DIR, 'symlink_to_file')
FileUtils.ln_s(REAL_FILE, SYMLINK_TO_FILE)
SYMLINK_TO_DIRECTORY = File.join(PARENT_DIR, 'symlink_to_directory')
FileUtils.ln_s(REAL_DIRECTORY, SYMLINK_TO_DIRECTORY)

RSpec.describe File do
  context 'for a real file' do
    it { expect(File.directory?(REAL_FILE)).to be false }
    it { expect(File.stat(REAL_FILE).directory?).to be false }
    it { expect(File.lstat(REAL_FILE).directory?).to be false }
    it { expect(Pathname.new(REAL_FILE).directory?).to be false }

    it { expect(File.symlink?(REAL_FILE)).to be false }
    it { expect(File.stat(REAL_FILE).symlink?).to be false }
    it { expect(File.lstat(REAL_FILE).symlink?).to be false }
    it { expect(Pathname.new(REAL_FILE).symlink?).to be false }

    it { expect(File.file?(REAL_FILE)).to be true }
    it { expect(File.stat(REAL_FILE).file?).to be true }
    it { expect(File.lstat(REAL_FILE).file?).to be true }
    it { expect(Pathname.new(REAL_FILE).file?).to be true }

    it { expect(File.ftype(REAL_FILE)).to eq "file" }
    it { expect(File.stat(REAL_FILE).ftype).to eq "file" }
    it { expect(File.lstat(REAL_FILE).ftype).to eq "file" }
    it { expect(Pathname.new(REAL_FILE).ftype).to eq "file" }
  end

  context 'for a real directory' do
    it { expect(File.directory?(REAL_DIRECTORY)).to be true }
    it { expect(File.stat(REAL_DIRECTORY).directory?).to be true }
    it { expect(File.lstat(REAL_DIRECTORY).directory?).to be true }
    it { expect(Pathname.new(REAL_DIRECTORY).directory?).to be true }

    it { expect(File.symlink?(REAL_DIRECTORY)).to be false }
    it { expect(File.stat(REAL_DIRECTORY).symlink?).to be false }
    it { expect(File.lstat(REAL_DIRECTORY).symlink?).to be false }
    it { expect(Pathname.new(REAL_DIRECTORY).symlink?).to be false }

    it { expect(File.file?(REAL_DIRECTORY)).to be false }
    it { expect(File.stat(REAL_DIRECTORY).file?).to be false }
    it { expect(File.lstat(REAL_DIRECTORY).file?).to be false }
    it { expect(Pathname.new(REAL_DIRECTORY).file?).to be false }

    it { expect(File.ftype(REAL_DIRECTORY)).to eq "directory" }
    it { expect(File.stat(REAL_DIRECTORY).ftype).to eq "directory" }
    it { expect(File.lstat(REAL_DIRECTORY).ftype).to eq "directory" }
    it { expect(Pathname.new(REAL_DIRECTORY).ftype).to eq "directory" }
  end

  context 'for a symlink to a file' do
    it { expect(File.directory?(SYMLINK_TO_FILE)).to be false }
    it { expect(File.stat(SYMLINK_TO_FILE).directory?).to be false }
    it { expect(File.lstat(SYMLINK_TO_FILE).directory?).to be false }
    it { expect(Pathname.new(SYMLINK_TO_FILE).directory?).to be false }

    it { expect(File.symlink?(SYMLINK_TO_FILE)).to be true }
    it { expect(File.stat(SYMLINK_TO_FILE).symlink?).to be false }
    it { expect(File.lstat(SYMLINK_TO_FILE).symlink?).to be true } # fails on jruby
    it { expect(Pathname.new(SYMLINK_TO_FILE).symlink?).to be true }

    it { expect(File.file?(SYMLINK_TO_FILE)).to be true }
    it { expect(File.stat(SYMLINK_TO_FILE).file?).to be true }
    it { expect(File.lstat(SYMLINK_TO_FILE).file?).to be false } # fails on jruby
    it { expect(Pathname.new(SYMLINK_TO_FILE).file?).to be true }

    it { expect(File.ftype(SYMLINK_TO_FILE)).to eq "link" } # fails on jruby
    it { expect(File.stat(SYMLINK_TO_FILE).ftype).to eq "file" }
    it { expect(File.lstat(SYMLINK_TO_FILE).ftype).to eq "link" } # fails on jruby
    it { expect(Pathname.new(SYMLINK_TO_FILE).ftype).to eq "link" } # fails on jruby
  end

  context 'for a symlink to a directory' do
    it { expect(File.directory?(SYMLINK_TO_DIRECTORY)).to be true }
    it { expect(File.stat(SYMLINK_TO_DIRECTORY).directory?).to be true }
    it { expect(File.lstat(SYMLINK_TO_DIRECTORY).directory?).to be false } # fails on jruby
    it { expect(Pathname.new(SYMLINK_TO_DIRECTORY).directory?).to be true }

    it { expect(File.symlink?(SYMLINK_TO_DIRECTORY)).to be true }
    it { expect(File.stat(SYMLINK_TO_DIRECTORY).symlink?).to be false }
    it { expect(File.lstat(SYMLINK_TO_DIRECTORY).symlink?).to be true } # fails on jruby
    it { expect(Pathname.new(SYMLINK_TO_DIRECTORY).symlink?).to be true }

    it { expect(File.file?(SYMLINK_TO_DIRECTORY)).to be false }
    it { expect(File.stat(SYMLINK_TO_DIRECTORY).file?).to be false }
    it { expect(File.lstat(SYMLINK_TO_DIRECTORY).file?).to be false }
    it { expect(Pathname.new(SYMLINK_TO_DIRECTORY).file?).to be false }

    it { expect(File.ftype(SYMLINK_TO_DIRECTORY)).to eq "link" } # fails on jruby
    it { expect(File.stat(SYMLINK_TO_DIRECTORY).ftype).to eq "directory" }
    it { expect(File.lstat(SYMLINK_TO_DIRECTORY).ftype).to eq "link" } # fails on jruby
    it { expect(Pathname.new(SYMLINK_TO_DIRECTORY).ftype).to eq "link" } # fails on jruby
  end
end
