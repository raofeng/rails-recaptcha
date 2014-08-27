require 'RMagick'
class NoisyImage
  include Magick
  def initialize(width=120, height=40, len=4)
    # 字符大小
    pointsize = (width / len).to_i
    # 宽度
    #width = pointsize * len
    # 高度
    #height = 40
    # 倾斜度
    rotation = 20
    # 横线条数
    line_count = 5
    # 点个数
    point_count = 100 * len
    # 允许的字符列表
    chars = ((0..9).to_a - [0,1]) + (('a'..'z').to_a - ['a','e','i','l','o','u'])
    # 背景色
    bg_colors = [
      '#FFFFCC',
      '#DFDFDF',
      '#CCFFCC',
      '#CCCCFF',
      '#DDDDDD',
      '#99CC66',
      '#F0FFF0',
      '#EBFFC2',
      '#FFD6EB',
      '#FFD1D1',
      '#C2F0FF',
      '#FFF5CC',
      '#F0C2B2'
    ]
    # 字体颜色
    font_colors = [
      '#003333',
      '#003366',
      '#009966',
      '#00FFCC',
      '#9933FF',
      '#9999CC',
      '#CC0066',
      '#FF9966',
      '#99FF33',
      '#B2246B',
      '#FF6666',
      '#2EB8E6',
      '#E6B800',
      '#CC3300'
    ]
    # 字符上的横线
    decorates = [
      UnderlineDecoration,
      OverlineDecoration,
      LineThroughDecoration
    ]
    # 字体列表
    font_families = ['Times', 'Verdana', 'Courier']
    # 生成的验证码字条列表
    code_array=[]
    1.upto(len) {code_array << chars[rand(chars.length)].to_s}
    # 背景色
    granite = Magick::ImageList.new('xc:' + bg_colors[rand(bg_colors.length)])
    canvas = Magick::ImageList.new
    # 填充颜色
    canvas.new_image(width, height, Magick::TextureFill.new(granite))
    gc = Magick::Draw.new
    gc.font_family = 'Times'
    gc.pointsize = pointsize
    x = 5
    # 生成字符
    code_array.each{|c|
      rand(10) > 5 ? rot = rand(rotation) : rot = -rand(rotation)
      rand(10) > 5 ? weight = NormalWeight : weight = BoldWeight
      gc.annotate(canvas, 0, 0, x, (pointsize - 5) + rand(height - pointsize), c){
        self.rotation = rot
        self.font_weight = weight
        self.undercolor = bg_colors[rand(bg_colors.length)]
        self.font_family = font_families[rand(font_families.length)]
        self.fill = font_colors[rand(font_colors.length)]
        self.decorate = decorates[rand(decorates.length)]
        self.stroke = '#666666'
      }
      x += pointsize
    }
    # 生成线
    gc.stroke_linejoin('round')
    1.upto(line_count){
      gc.stroke(font_colors[rand(font_colors.length)])
      gc.stroke_width(1)
      gc.line(rand(width),rand(height), rand(width),rand(height))
    }
    # 生成点
    1.upto(point_count){
      gc.fill(font_colors[rand(font_colors.length)])
      gc.point(rand(width),rand(height))
    }
    gc.draw(canvas)

    @code = code_array.join('')
    @image = canvas.to_blob{
      self.format="jpg"
    }
  end

  def code
    @code
  end

  def image
    @image
  end
end