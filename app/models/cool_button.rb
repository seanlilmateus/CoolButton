class CoolButton < UIButton
  include DrawHelpers
  attr_accessor :hue, :saturation, :brightness
  
  def initWithFrame(frame)
    if super
      button_setup
    end
    self
  end
  
  def initWithCoder(a_decoder)
    if super
      button_setup
    end
    self
  end
  
  def button_setup
    self.opaque = false
    self.backgroundColor = UIColor.clearColor
    @hue = 1.0
    @saturation = 1.0
    @brightness = 1.0
  end
  
  def drawRect(rect)
    super
    context = UIGraphicsGetCurrentContext()
    
    actual_brightness = @brightness
    actual_brightness -= 0.10 if self.state == UIControlStateHighlighted
    
    black_color = UIColor.colorWithWhite(0.40, alpha:1.0).CGColor 
    #UIColor.colorWithRed(0.0, green:0.0, blue:0.0, alpha:1.0).CGColor

    highlight_start = UIColor.colorWithRed(1.0, green:1.0, blue:1.0, alpha:0.4).CGColor
    highlight_stop = UIColor.colorWithRed(1.0, green:1.0, blue:1.0, alpha:0.1).CGColor
    shadow_color = UIColor.colorWithRed(0.2, green:0.2, blue:0.2, alpha:0.5).CGColor
        
    outer_top = UIColor.colorWithHue(@hue, saturation:@saturation, brightness:1.0 * actual_brightness, alpha:1.0).CGColor
    outer_bottom = UIColor.colorWithHue(@hue, saturation:@saturation, brightness:0.80 * actual_brightness, alpha:1.0).CGColor
    inner_stroke = UIColor.colorWithHue(@hue, saturation:@saturation, brightness:0.80 * actual_brightness, alpha:1.0).CGColor
    inner_top = UIColor.colorWithHue(@hue, saturation:@saturation, brightness:0.90 * actual_brightness, alpha:1.0).CGColor
    inner_bottom = UIColor.colorWithHue(@hue, saturation:@saturation, brightness:0.70 * actual_brightness, alpha:1.0).CGColor
    
    outer_margin = 5.0
    outer_rect = CGRectInset(self.bounds, outer_margin, outer_margin)       
    outer_path = createRoundedRectForRect(outer_rect, 6.0)
    
    inner_margin = 3.0
    inner_rect = CGRectInset(outer_rect, inner_margin, inner_margin)
    inner_path = createRoundedRectForRect(inner_rect, 3.0)
    
    highlight_margin = 2.0
    highlight_rect = CGRectInset(outer_rect, highlight_margin, highlight_margin)
    highlight_path = createRoundedRectForRect(highlight_rect, 6.0)
    
    # Draw shadow
    unless (self.state == UIControlStateHighlighted)
      CGContextState(context) do
        CGContextSetFillColorWithColor(context, outer_top)
        CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadow_color)
        CGContextAddPath(context, outer_path)
        CGContextFillPath(context)
      end
    end
    
    # Draw gradient for outer path
    CGContextState(context) do
      CGContextAddPath(context, outer_path)
      CGContextClip(context)
      drawGlossAndGradient(context, outer_rect, outer_top, outer_bottom)
    end
    
    # Draw gradient for inner path
    CGContextState(context) do
      CGContextAddPath(context, inner_path)
      CGContextClip(context)
      drawGlossAndGradient(context, inner_rect, inner_top, inner_bottom)
    end
    
    
    # Draw highlight (if not selected)
    unless self.state == UIControlStateHighlighted
      CGContextState(context) do
        CGContextSetLineWidth(context, 4.0)
        CGContextAddPath(context, outer_path)
        CGContextAddPath(context, highlight_path)
        CGContextEOClip(context)
        drawLinearGradient(context, outer_rect, highlight_start, highlight_stop)
      end
    end
    
    # Stroke outer path
    CGContextState(context) do
      CGContextSetLineWidth(context, 2.0)
      CGContextSetStrokeColorWithColor(context, black_color)
      CGContextAddPath(context, outer_path)
      CGContextStrokePath(context)
    end
    
    # Stroke inner path
    CGContextState(context) do
      CGContextSetLineWidth(context, 2.0)
      CGContextSetStrokeColorWithColor(context, inner_stroke)
      CGContextAddPath(context, inner_path)
      CGContextClip(context)
      CGContextAddPath(context, inner_path)
      CGContextStrokePath(context)
    end        
  end
  
  def hue=(value)
    @hue = value
    self.setNeedsDisplay
  end
  
  def saturation=(value)
    @saturation = value
    self.setNeedsDisplay
  end
  
  def brightness=(value)
    @brightness = value
    self.setNeedsDisplay
  end
  
  def hesitate_update
    self.setNeedsDisplay
  end
  
  def touchesBegan(touches, withEvent:the_event)
    super
    self.setNeedsDisplay
  end
  
  def touchesMoved(touches, withEvent:the_event)
    super
    self.setNeedsDisplay
  end
  
  def touchesCancelled(touches, withEvent:the_event)
    super
    self.setNeedsDisplay
    self.performSelector(:hesitate_update, withObject:nil, afterDelay:0.1)
  end
  
  def touchesEnded(touches, withEvent:the_event)
    super
    self.setNeedsDisplay
    self.performSelector(:hesitate_update, withObject:nil, afterDelay:0.1)
  end
end