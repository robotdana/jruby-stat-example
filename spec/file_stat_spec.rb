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
  end
end
