module DrawHelpers

  def CGContextState(context)
    CGContextSaveGState(context);
    yield
    CGContextRestoreGState(context);
  end

  def rectFor1PxStroke(rect)
    CGRectMake(rect.origin.x + 0.5, rect.origin.y + 0.5, rect.size.width - 1, rect.size.height - 1)
  end
  
  def drawLinearGradient(context, rect, start_color, end_color)
    color_space = CGColorSpaceCreateDeviceRGB()
    locations = Pointer.new(:float, 2)
    locations[1]  = 1.0
    
    colors = [start_color, end_color]
    
    gradient = CGGradientCreateWithColors(color_space, colors, locations)
    
    start_point = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect))
    end_point = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect))
    
    CGContextState(context) do
      CGContextAddRect(context, rect)
      CGContextClip(context)
      CGContextDrawLinearGradient(context, gradient, start_point, end_point, 0)
    end  
  end
  
  def draw1PxStroke(context, start_point, end_point, color)
    CGContextState(context) do
      CGContextSetLineCap(context, KCGLineCapSquare)
      CGContextSetStrokeColorWithColor(context, color)
      CGContextSetLineWidth(context, 1.0)
      CGContextMoveToPoint(context, start_point.x + 0.5, start_point.y + 0.5)
      CGContextAddLineToPoint(context, end_point.x + 0.5, end_point.y + 0.5)
      CGContextStrokePath(context)
    end       
  end
  
  def drawGlossAndGradient(context, rect, start_color, end_color)
    drawLinearGradient(context, rect, start_color, end_color);
    
    gloss_color1 = UIColor.colorWithRed(1.0, green:1.0, blue:1.0, alpha:0.35).CGColor
    gloss_color2 = UIColor.colorWithRed(1.0, green:1.0, blue:1.0, alpha:0.1).CGColor
    
    top_half = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2)
    
    drawLinearGradient(context, top_half, gloss_color1, gloss_color2)
  end
  
  def createArcPathFromBottomOfRect(rect, arc_height)
    arc_rect = CGRectMake(rect.origin.x, rect.origin.y + rect.size.height - arc_height, rect.size.width, arc_height);
    
    arc_radius = ((arc_rect.size.height/2) + (arc_rect.size.width ** 2) / (8*arc_rect.size.height))
    arc_center = CGPointMake(arc_rect.origin.x + arc_rect.size.width/2, arc_rect.origin.y + arc_radius)
    
    angle = MATH.acos(arc_rect.size.width / (2*arc_radius))
    start_angle = to_rad(180) + angle
    end_angle = to_rad(360) - angle
    
    path = CGPathCreateMutable()
    CGPathAddArc(path, nil, arc_center.x, arc_center.y, arc_radius, start_angle, end_angle, 0)
    CGPathAddLineToPoint(path, nil, CGRectGetMaxX(rect), CGRectGetMinY(rect))
    CGPathAddLineToPoint(path, nil, CGRectGetMinX(rect), CGRectGetMinY(rect))
    CGPathAddLineToPoint(path, nil, CGRectGetMinX(rect), CGRectGetMaxY(rect))
    path
  end  
  
  
  def createRoundedRectForRect(rect, radius)
    path = CGPathCreateMutable()
    CGPathMoveToPoint(path, nil, CGRectGetMidX(rect), CGRectGetMinY(rect))
    CGPathAddArcToPoint(path, nil, CGRectGetMaxX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius)
    CGPathAddArcToPoint(path, nil, CGRectGetMaxX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMaxY(rect), radius)
    CGPathAddArcToPoint(path, nil, CGRectGetMinX(rect), CGRectGetMaxY(rect), CGRectGetMinX(rect), CGRectGetMinY(rect), radius)
    CGPathAddArcToPoint(path, nil, CGRectGetMinX(rect), CGRectGetMinY(rect), CGRectGetMaxX(rect), CGRectGetMinY(rect), radius)
    CGPathCloseSubpath(path)    
    path
  end
  
  def to_rad(angle)
    angle / 180 * Math::PI
  end
end