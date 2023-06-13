--[[
    version - 0.0.1
    
    A tweener module for easing anything.

    The current supported objects that you can tween are:
        - Numbers
        - Tables
    
    // TWEENER INFO //
    Duration - The duration of the tween.
    EasingStyle (DEFAULT: "Linear") - The easing style that should be played.
    EasingDirection (DEFAULT: "In") - The direction the tween should be played in. There are currently four: In, Out, InOut, OutIn
    DelayTime - How much time should be waited until the tween plays. This counts for every time you play the tween.
    DestroyOnEnd - If the tween should be destroyed after it ends.

    --------------------------------------------------------------------------------------------------------------------
    The easing functions are imported from 'https://github.com/EmmanuelOga/easing/'. See LICENSE for further credits.
    --------------------------------------------------------------------------------------------------------------------
    
    // SOME NOTES //
    I originally implemented this as a library file for Love2D.
    But, you may somehow use it in the actual Lua as well.

    The Play function uses 'dt' (delta time) to add to the 'run' property so the tween can play.
    In my opinion, you can use: 'os.clock() % 1' and somehow add it as 'dt' in a loop.
    ---------------------------------------------------------------------------------------------

    =============================================================================
                                       LICENSE
    =============================================================================

    MIT License

    Copyright (c) 2023 Ivankovich

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.

    =============================================================================

    Author: Dno234
]]

local Tweener = {}

local pow = math.pow
local sin = math.sin
local cos = math.cos
local pi = math.pi
local sqrt = math.sqrt
local abs = math.abs
local asin  = math.asin

Tweener.EasingFunctions = {
    Linear = function(t, b, c, d)
        return c * t / d + b
    end,

    InQuad = function(t, b, c, d)
        t = t / d
        return c * pow(t, 2) + b
    end,

    OutQuad = function(t, b, c, d)
        t = t / d
        return -c * t * (t - 2) + b
    end,
    
    InOutQuad = function(t, b, c, d)
      t = t / d * 2
      if t < 1 then
        return c / 2 * pow(t, 2) + b
      else
        return -c / 2 * ((t - 1) * (t - 3) - 1) + b
      end
    end,
    
    OutInQuad = function(t, b, c, d)
      if t < d / 2 then
        return Tweener.EasingFunctions.OutQuad(t * 2, b, c / 2, d)
      else
        return Tweener.EasingFunctions.InQuad((t * 2) - d, b + c / 2, c / 2, d)
      end
    end,
    
    InCubic = function(t, b, c, d)
      t = t / d
      return c * pow(t, 3) + b
    end,
    
    OutCubic = function(t, b, c, d)
      t = t / d - 1
      return c * (pow(t, 3) + 1) + b
    end,
    
    InOutCubic = function(t, b, c, d)
      t = t / d * 2
      if t < 1 then
        return c / 2 * t * t * t + b
      else
        t = t - 2
        return c / 2 * (t * t * t + 2) + b
      end
    end,
    
    OutInCubic = function(t, b, c, d)
      if t < d / 2 then
        return Tweener.EasingFunctions.OutCubic(t * 2, b, c / 2, d)
      else
        return Tweener.EasingFunctions.InCubic((t * 2) - d, b + c / 2, c / 2, d)
      end
    end,
    
    InQuart = function(t, b, c, d)
      t = t / d
      return c * pow(t, 4) + b
    end,
    
    OutQuart = function(t, b, c, d)
      t = t / d - 1
      return -c * (pow(t, 4) - 1) + b
    end,
    
    InOutQuart = function(t, b, c, d)
      t = t / d * 2
      if t < 1 then
        return c / 2 * pow(t, 4) + b
      else
        t = t - 2
        return -c / 2 * (pow(t, 4) - 2) + b
      end
    end,
    
    OutInQuart = function(t, b, c, d)
      if t < d / 2 then
        return Tweener.EasingFunctions.OutQuart(t * 2, b, c / 2, d)
      else
        return Tweener.EasingFunctions.InQuart((t * 2) - d, b + c / 2, c / 2, d)
      end
    end,
    
    InQuint = function(t, b, c, d)
      t = t / d
      return c * pow(t, 5) + b
    end,
    
    OutQuint = function(t, b, c, d)
      t = t / d - 1
      return c * (pow(t, 5) + 1) + b
    end,
    
    InOutQuint = function(t, b, c, d)
      t = t / d * 2
      if t < 1 then
        return c / 2 * pow(t, 5) + b
      else
        t = t - 2
        return c / 2 * (pow(t, 5) + 2) + b
      end
    end,
    
    OutInQuint = function(t, b, c, d)
      if t < d / 2 then
        return Tweener.EasingFunctions.OutQuint(t * 2, b, c / 2, d)
      else
        return Tweener.EasingFunctions.InQuint((t * 2) - d, b + c / 2, c / 2, d)
      end
    end,
    
    InSine = function(t, b, c, d)
      return -c * cos(t / d * (pi / 2)) + c + b
    end,
    
    OutSine = function(t, b, c, d)
      return c * sin(t / d * (pi / 2)) + b
    end,
    
    InOutSine = function(t, b, c, d)
      return -c / 2 * (cos(pi * t / d) - 1) + b
    end,
    
    OutInSine = function(t, b, c, d)
      if t < d / 2 then
        return Tweener.EasingFunctions.OutSine(t * 2, b, c / 2, d)
      else
        return Tweener.EasingFunctions.InSine((t * 2) -d, b + c / 2, c / 2, d)
      end
    end,
    
    InExpo = function(t, b, c, d)
      if t == 0 then
        return b
      else
        return c * pow(2, 10 * (t / d - 1)) + b - c * 0.001
      end
    end,
    
    OutExpo = function(t, b, c, d)
      if t == d then
        return b + c
      else
        return c * 1.001 * (-pow(2, -10 * t / d) + 1) + b
      end
    end,
    
    InOutExpo = function(t, b, c, d)
      if t == 0 then return b end
      if t == d then return b + c end
      t = t / d * 2
      if t < 1 then
        return c / 2 * pow(2, 10 * (t - 1)) + b - c * 0.0005
      else
        t = t - 1
        return c / 2 * 1.0005 * (-pow(2, -10 * t) + 2) + b
      end
    end,
    
    OutInExpo = function(t, b, c, d)
      if t < d / 2 then
        return Tweener.EasingFunctions.OutExpo(t * 2, b, c / 2, d)
      else
        return Tweener.EasingFunctions.InExpo((t * 2) - d, b + c / 2, c / 2, d)
      end
    end,
    
    InCirc = function(t, b, c, d)
      t = t / d
      return(-c * (sqrt(1 - pow(t, 2)) - 1) + b)
    end,
    
    OutCirc = function(t, b, c, d)
      t = t / d - 1
      return(c * sqrt(1 - pow(t, 2)) + b)
    end,
    
    InOutCirc = function(t, b, c, d)
      t = t / d * 2
      if t < 1 then
        return -c / 2 * (sqrt(1 - t * t) - 1) + b
      else
        t = t - 2
        return c / 2 * (sqrt(1 - t * t) + 1) + b
      end
    end,
    
    OutInCirc = function(t, b, c, d)
      if t < d / 2 then
        return Tweener.EasingFunctions.OutCirc(t * 2, b, c / 2, d)
      else
        return Tweener.EasingFunctions.InCirc((t * 2) - d, b + c / 2, c / 2, d)
      end
    end,
    
    InElastic = function(t, b, c, d, a, p)
      if t == 0 then return b end
    
      t = t / d
    
      if t == 1  then return b + c end
    
      if not p then p = d * 0.3 end
    
      local s
    
      if not a or a < abs(c) then
        a = c
        s = p / 4
      else
        s = p / (2 * pi) * asin(c/a)
      end
    
      t = t - 1
    
      return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
    end,
    
    -- a: amplitud
    -- p: period
    OutElastic = function(t, b, c, d, a, p)
      if t == 0 then return b end
    
      t = t / d
    
      if t == 1 then return b + c end
    
      if not p then p = d * 0.3 end
    
      local s
    
      if not a or a < abs(c) then
        a = c
        s = p / 4
      else
        s = p / (2 * pi) * asin(c/a)
      end
    
      return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p) + c + b
    end,
    
    -- p = period
    -- a = amplitud
    InOutElastic = function(t, b, c, d, a, p)
      if t == 0 then return b end
    
      t = t / d * 2
    
      if t == 2 then return b + c end
    
      if not p then p = d * (0.3 * 1.5) end
      if not a then a = 0 end
    
      local s
    
      if not a or a < abs(c) then
        a = c
        s = p / 4
      else
        s = p / (2 * pi) * asin(c / a)
      end
    
      if t < 1 then
        t = t - 1
        return -0.5 * (a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b
      else
        t = t - 1
        return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p ) * 0.5 + c + b
      end
    end,
    
    -- a: amplitud
    -- p: period
    OutInElastic = function(t, b, c, d, a, p)
      if t < d / 2 then
        return Tweener.EasingFunctions.OutElastic(t * 2, b, c / 2, d, a, p)
      else
        return Tweener.EasingFunctions.InElastic((t * 2) - d, b + c / 2, c / 2, d, a, p)
      end
    end,
    
    InBack = function(t, b, c, d, s)
      if not s then s = 1.70158 end
      t = t / d
      return c * t * t * ((s + 1) * t - s) + b
    end,
    
    OutBack = function(t, b, c, d, s)
      if not s then s = 1.70158 end
      t = t / d - 1
      return c * (t * t * ((s + 1) * t + s) + 1) + b
    end,
    
    InOutBack = function(t, b, c, d, s)
      if not s then s = 1.70158 end
      s = s * 1.525
      t = t / d * 2
      if t < 1 then
        return c / 2 * (t * t * ((s + 1) * t - s)) + b
      else
        t = t - 2
        return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b
      end
    end,
    
    OutInBack = function(t, b, c, d, s)
      if t < d / 2 then
        return Tweener.EasingFunctions.OutBack(t * 2, b, c / 2, d, s)
      else
        return Tweener.EasingFunctions.InBack((t * 2) - d, b + c / 2, c / 2, d, s)
      end
    end,
    
    OutBounce = function(t, b, c, d)
      t = t / d
      if t < 1 / 2.75 then
        return c * (7.5625 * t * t) + b
      elseif t < 2 / 2.75 then
        t = t - (1.5 / 2.75)
        return c * (7.5625 * t * t + 0.75) + b
      elseif t < 2.5 / 2.75 then
        t = t - (2.25 / 2.75)
        return c * (7.5625 * t * t + 0.9375) + b
      else
        t = t - (2.625 / 2.75)
        return c * (7.5625 * t * t + 0.984375) + b
      end
    end,
    
    InBounce = function(t, b, c, d)
      return c - Tweener.EasingFunctions.OutBounce(d - t, 0, c, d) + b
    end,
    
    InOutBounce = function(t, b, c, d)
      if t < d / 2 then
        return Tweener.EasingFunctions.InBounce(t * 2, 0, c, d) * 0.5 + b
      else
        return Tweener.EasingFunctions.OutBounce(t * 2 - d, 0, c, d) * 0.5 + c * .5 + b
      end
    end,
    
    OutInBounce = function(t, b, c, d)
      if t < d / 2 then
        return Tweener.EasingFunctions.OutBounce(t * 2, b, c / 2, d)
      else
        return Tweener.EasingFunctions.InBounce((t * 2) - d, b + c / 2, c / 2, d)
      end
    end
}

-- PRIVATE FUNCTIONS --
local function getSelectedEaser(selected, dir)
    assert(selected, "Please specify a easer!")
    assert(Tweener.EasingFunctions[selected] or Tweener.EasingFunctions[dir..selected], "The specified easer cannot be found.")

    local foundEaser = Tweener.EasingFunctions[dir..selected]

    if selected == "Linear" then
        foundEaser = Tweener.EasingFunctions[selected]
    end
    
    return foundEaser
end

local function runTweener(subject, goal, dur, runTime, easerFunc)
    if type(goal) == "table" then
        for prop, val in pairs(goal) do
          if type(val) == "table" then
            runTweener(subject[prop], val, dur, runTime, easerFunc)
          elseif type(val) == "number" then
            subject[prop] = easerFunc(runTime, subject[prop], val - subject[prop], dur)
          end
        end
    elseif type(goal) == "number" then
      subject = easerFunc(runTime, subject, goal - subject, dur)
    end
end
-----------------------

local TweenBase = {}
TweenBase.__index = TweenBase

function Tweener.new(subject, goal, tweeningInfo)
    assert(subject, "Please specify a subject to tween!")
    assert(type(subject) == "number" or type(subject) == "table", "This subject is not supported to tween!")
    
    local self = setmetatable({}, TweenBase)

    self.subject = subject
    self.props = goal
    self.tweenInfo = tweeningInfo ~= nil and tweeningInfo or Tweener.newTweenerInfo()
    self.paused = false

    local dTime = self.tweenInfo.DelayTime
    
    self.eFunc = getSelectedEaser(self.tweenInfo.EasingStyle, self.tweenInfo.EasingDirection)
    self.run = 0

    function self:Toggle()
        self.paused = not self.paused
    end

    function self:Stop()
        if not self.paused then
            self.run = 0
            self.paused = true

            if dTime <= 0 then
                dTime = self.tweenInfo.DelayTime
            end
        end
    end
    
    function self:update()
        if self.run <= 0 then
            self.run = 0
        elseif self.run >= self.tweenInfo.Duration then
            self:Stop()

            if self.tweenInfo.DestroyOnEnd then
                self:Destroy()
            end
        end

        runTweener(self.subject, self.props, self.tweenInfo.Duration, self.run, self.eFunc)
    end

    function self:Destroy()
        self:Stop()

        self = nil
    end

    function self:Restart()
        self.run = 0
    end

    function self:Play(dt)
        if dTime > 0 then
            dTime = dTime - dt
            return
        end

        if not self.paused then
          assert(type(dt) == "number", "'dt' must be a number!")

          self.run = self.run + dt
          self:update()
        end
    end

    return self
end

function Tweener.newTweenerInfo(dur, easing, direction, dOd, delayTime)
    local tInfo = {
        Duration = dur or 1,
        EasingStyle = easing or "Linear",
        EasingDirection = direction or "In",
        DestroyOnEnd = dOd or false,
        DelayTime = delayTime or 0
    }

    return tInfo
end

return Tweener
