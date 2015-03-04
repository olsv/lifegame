a = '  1 1  1  ' +
    '  1     11' +
    '1 11      ' +
    '   1      ' +
    '       1  ' +
    '    1 1   ' +
    '  1      1' +
    '  1   1   ' +
    '        1 ' +
    ' 1  1     '



b = '        1 ' +
    '  1     1 ' +
    ' 111      ' +
    '  11      ' +
    '          ' +
    '          ' +
    '   1 1    ' +
    '          ' +
    '          ' +
    '          '
require 'pry'


class World
  attr_reader :width, :height, :state
  def initialize(width, height, state)
    @width = width
    @height = height
    @state = parse_state(state)
    mutate
  end

  def mutate
    p  "===================================="
    sleep(1)
    World.new(width, height, serialize)
  end

  def parse_state(state)
    n = 0
    state.split('').map do |el|
      y, x = n.divmod width
      n += 1
      Cell.new(x, y, self, el.to_i)
    end
  end

  def neighbours_for(obj)
    xr = (obj.x-1 .. obj.x+1).to_a
    yr = (obj.y-1 .. obj.y+1).to_a
    ids = yr.map{|y| yy = width * y; xr.map{|k| k + yy }  }.flatten.reject{|id| (id < 0) || (id > (width * height) - 1) }
    state.values_at(*ids).reject{|k| k.eql? obj }
  end

  def serialize
    result = state.map(&:to_s)
    result.each_slice(width).map{|k| $stdout << k.join << "\n" }
    result.join
  end
end

class Cell
  attr_reader :x, :y, :world, :state
  def initialize(x, y, world, state)
    @x = x
    @y = y
    @world = world
    @state = state
    @new_state = nil
  end

  def neighbours
    @heighbours = world.neighbours_for(self).reject{|k| k.dead?}
  end

  def new_state
    if self.live?
      (neighbours.count < 2) || (neighbours.count > 3) ? 0 : 1
    else
      neighbours.count == 3 ? 1 : 0
    end
  end

  def to_s
    new_state == 1 ? 1 : '0'
  end

  def live?
    @state == 1
  end

  def dead?
    !live?
  end
end

describe World do
  let(:initial_state){
    '  1 1  1  ' +
    '  1     11' +
    '1 11      ' +
    '   1      ' +
    '       1  ' +
    '    1 1   ' +
    '  1      1' +
    '  1   1   ' +
    '        1 ' +
    ' 1  1     '
  }

  let(:finite_state) {
    '  1 1  1  ' +
    '  1     11' +
    '1 11      ' +
    '   1      ' +
    '       1  ' +
    '    1 1   ' +
    '  1      1' +
    '  1   1   ' +
    '        1 ' +
    ' 1  1     '
  }

  let(:world){ World.new(10, 15, initial_state) }
  let(:live_cell){ Cell.new(1,0, world, 1) }


  it 'should accept width' do
    expect(world.width).to eql 10
  end

  it 'should accept height' do
    expect(world.height).to eql 15
  end

  it

end

describe Cell do
  let(:initial_state){
    '  1 1  1  ' +
    '  1     11' +
    '1 11      ' +
    '   1      ' +
    '       1  ' +
    '    1 1   ' +
    '  1      1' +
    '  1   1   ' +
    '        1 ' +
    ' 1  1     '
  }

  let(:world){ World.new(10, 10, initial_state) }
  #let(:live_cell){ Cell.new(1,0, world, 1) }
  #let(:dead_cell){ Cell.new(1,0, world, 0) }



  it 'should respond to x' do
    binding.pry
    expect(live_cell.x).to eql 1
  end
  it 'should respond to y' do
    expect(live_cell.y).to eql 0
  end

  it 'should respond to world' do
    expect(live_cell.world).to eql world
  end

  describe 'live?' do
    it 'should be true for live cell' do
      expect(live_cell.live?).to eql true
    end
    it 'should be false for dead cell' do
      expect(dead_cell.live?).to eql false
    end
  end

  describe 'dead?' do
    it 'should be true for dead cell' do
      expect(dead_cell.dead?).to eql true
    end
    it 'should be false for live cell' do
      expect(live_cell.dead?).to eql false
    end
  end
end