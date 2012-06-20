require 'dilation/utils/counter'

describe Dilation::Utils::Counter do
  before do
    @counter = 0
    @blk = lambda { @counter += 1 }
  end

  context "when uninverted" do
    it { subject.should_not be_inverted }

    it "inverts" do
      expect { subject.invert }.to change { subject.inverted? }
    end

    it "doesn't uninvert" do
      expect { subject.uninvert }.not_to change { subject.inverted? }
    end

    it "defaults to 1 run per tick" do
      expect { |b| subject.run(&b) }.to yield_control
    end

    it "runs n times per tick if factor is set to n" do
      subject.factor = 2
      subject.run &@blk
      @counter.should == 2
    end

    it "runs fractional factors" do
      subject.factor = 1.5
      subject.run &@blk
      @counter.should == 1
      subject.run &@blk
      @counter.should == 3
    end
  end

  context "when inverted" do
    before do
      subject.invert
    end

    it { subject.should be_inverted }

    it "inverts" do
      expect { subject.invert }.not_to change { subject.inverted? }
    end

    it "doesn't uninvert" do
      expect { subject.uninvert }.to change { subject.inverted? }
    end

    it "runs once every n times if factor is set to n and object is inverted" do
      subject.factor = 3
      3.times { subject.run &@blk }
      @counter.should == 1
    end

    it "resets the count when factor is changed" do
      subject.factor = 2
      subject.run &@blk
      subject.factor = 3
      2.times { subject.run &@blk }
      @counter.should == 0
    end

    it "runs fractional factors" do
      pending "floating point issue"
      subject.factor = 1.5
      3.times { subject.run &@blk }
      @counter.should == 2
    end

    it "resets the count when the inversion is changed" do
      pending "floating point"
      subject.invert
      subject.factor = 1.5
      subject.run &@blk
      subject.invert
      subject.run &@blk
      @counter.should == 1
    end
  end
end