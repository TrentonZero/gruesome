require_relative '../../lib/gruesome/z/memory'

describe Gruesome::Z::Memory do
  before(:each) do
    zork = File.open('test/zork1.z3', 'r')
    @zork_memory = Gruesome::Z::Memory.new(zork.read(zork.size), '')
  end

  describe "#readb" do
    it "should read a byte in header" do
      @zork_memory.readb(0x0).should eql(3)
    end

    it "should read a byte in dynamic memory" do
      @zork_memory.readb(0x100).should eql(32)
    end

    it "should read a byte in static memory" do
      @zork_memory.readb(0x2E53).should eql(47)
      @zork_memory.readb(0x4E36).should eql(0)
    end

    it "should not read a byte in high memory" do
      lambda {@zork_memory.readb(0x4E37)}.should raise_error(RuntimeError)
    end
  end

  describe "#readw" do
    it "should read a word in header" do
      @zork_memory.readw(0x0).should eql(768)
    end

    it "should read a word in dynamic memory" do
      @zork_memory.readw(0x100).should eql(8403)
    end

    it "should read a word in static memory" do
      @zork_memory.readw(0x2E53).should eql(12127)
      @zork_memory.readw(0x4E35).should eql(256)
    end

    it "should not read a word in high memory" do
      lambda{@zork_memory.readw(0x4E36)}.should raise_error(RuntimeError)
    end
  end

  describe "#writeb" do
    it "should write a byte in dynamic memory" do
      @zork_memory.writeb(0x100, 128)
      @zork_memory.readb(0x100).should eql(128)
    end

    it "should not write a byte in static memory" do
      @zork_memory.force_writeb(0x2E53, 123)
      lambda{@zork_memory.writeb(0x2E53, 128)}.should raise_error(RuntimeError)
      @zork_memory.readb(0x2E53).should eql(123)
      @zork_memory.force_writeb(0x4E36, 123)
      lambda{@zork_memory.writeb(0x4E36, 128)}.should raise_error(RuntimeError)
      @zork_memory.readb(0x4E36).should eql(123)
    end

    it "should not write a byte in high memory" do
      @zork_memory.force_writeb(0x4E37, 123)
      lambda{@zork_memory.writeb(0x4E37, 128)}.should raise_error(RuntimeError)
      @zork_memory.force_readb(0x4E37).should eql(123)
    end
  end

  describe "#writew" do
    it "should write a word in dynamic memory" do
      @zork_memory.writew(0x100, 12345)
      @zork_memory.readw(0x100).should eql(12345)
    end

    it "should not write a word in static memory" do
      @zork_memory.force_writew(0x2E53, 23456)
      lambda{@zork_memory.writew(0x2E53, 12345)}.should raise_error(RuntimeError)
      @zork_memory.readw(0x2E53).should eql(23456)
      @zork_memory.force_writew(0x4E35, 23456)
      lambda{@zork_memory.writew(0x4E35, 12345)}.should raise_error(RuntimeError)
      @zork_memory.readw(0x4E35).should eql(23456)
    end

    it "should not write a word in high memory" do
      @zork_memory.force_writew(0x4E36, 23456)
      lambda{@zork_memory.writew(0x4E36, 12345)}.should raise_error(RuntimeError)
      @zork_memory.force_readw(0x4E36).should eql(23456)
    end
  end
end
