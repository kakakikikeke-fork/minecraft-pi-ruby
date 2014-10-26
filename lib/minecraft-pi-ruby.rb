require_relative 'connection'
require_relative 'position'
require_relative 'blocks'

class Minecraft
  include Block
  
  def initialize(connection = nil)
    @connection = connection
    @connection ||= Connection.new
  end

  class << self
    def control(&script)
      mc = self.new
      mc.instance_eval(&script)
    end
    
    alias_method :world, :control
  end
  
  def say(message)
    @connection.send_command "chat.post(#{message})"
  end
  
  def set_camera_mode(mode)
    @connection.send_command 'camera.mode.setNormal' if mode == :normal
    @connection.send_command 'camera.mode.setFixed' if mode == :fixed
    @connection.send_command 'camera.mode.setFollow' if mode == :follow
  end
  
  def set_block(*args)
    command = "world.setBlock("
    case args.length
    when 2
      command = command + "#{args[0]},#{args[1]})"
    when 3
      command += "#{args[0]},#{args[1]},#{args[2]})"
    when 4
      command += "#{args[0]},#{args[1]},#{args[2]},#{args[3]})"
    when 5
      command += "#{args[0]},#{args[1]},#{args[2]},#{args[3]},#{args[4]})"
    else
      return
    end
    @connection.send_command command
  end
  
  def set_blocks(*args)
    command = "world.setBlocks("
    case args.length
    when 3
      command += "#{args[0]},#{args[1]},#{args[2]})"
    when 4
      command += "#{args[0]},#{args[1]},#{args[2]},#{args[3]})"
    when 7
      command += "#{args[0]},#{args[1]},#{args[2]},#{args[3]},#{args[4]},#{args[5]},#{args[6]})"
    when 8
      command += "#{args[0]},#{args[1]},#{args[2]},#{args[3]},#{args[4]},#{args[5]},#{args[6]},#{args[7]})"
    else
      return
    end
    @connection.send_command command
  end
  alias_method :make_cuboid, :set_blocks
  
  def get_ground_height(x,z)
    return  @connection.send_with_response "world.getHeight(#{x},#{z})"
    #return s
  end
  alias_method :ground_height, :get_ground_height
  
  def set_player_position(*args)
    command = "player.setPos("
    case args.length
    when 1
      command += "#{args[0].x},#{args[0].y},#{args[0].z})"
    when 3
      command += "#{args[0]},#{args[1]},#{args[2]})"
    else
      return
    end
    @connection.send_command command
  end
  
end
    
