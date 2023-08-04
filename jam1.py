change_bpm(120)

a1 >> apad(
    P[0],
    dur=PRand(4, 8)[:16],
    oct=6,
)
# a1.span(srot(128), .8)
a1.thick_thin=linvar([0,1,.4,.8,0,.6], PRand(2,24), start=Clock.mod(4))
a1.degree = P[0,4,-2] + P(0,4,5)
a1.space=linvar([0,1,.4,.8,0,.6],PRand(2,24), start=Clock.mod(4))
a1.detail=linvar([0,1,.4,.8,0,.6],PRand(2,24), start=Clock.mod(4))
a1.fade(48, fvol=.8, ivol=0)

ee >> fxstack(ru_blend=linvar([0,.5]), vdee_mix=linvar([0,1],7))

Root.default = var([0,2,4], 1)

dd >> play("[XX..XX.X]", rate=linvar([4,8], 32, start=Clock.mod(4)))
dd.fade(ivol=0, fvol=1)
dd.lpf = linvar([700,3000,300])
dd.lpf = linvar([300,20000,3000])
dd.lpf = linvar([100,800,300])
dd.rate = 1
dd.rate = PWhite(.5,5)
dd.degree = "[vvv..vvvvv..vv]"
dd.degree = "[vv]"
dd.degree = "v.."
dd.degree = "<c..><[***]>"
dd.output = 12

dd.pan = (
  linvar([-1,1], PRand(2,16))
  * 1
  * P[-.8,0,.7].stutter(2)
)

dd.fade(fvol=.2)
dd.amplify=linvar(P[.2]|PWhite(0,1.3), start=Clock.mod(4))

dd.pause(8, 32, smooth=.5)

b1 >> reese().fade(16,fvol=1)

m1 >> blip().fade(16, fvol=2)

dd.degree="<[**...***....***]><[--]>"
dd.ampfadeout(24)
dd.rate=linvar([.2,6],48)
dd.pan=PWhite(-1,1)

dd.rate=1

b2 >> blip(degree=linvar([2,10], 48, start=Clock.mod(4)), oct=8, amp=PWhite(0,1), dur=.125)
b2.amp=[1,0,0,1,1,0,1,1,1,0,0]
b2.amp=1
b2.pan=[-1,1,0,1,0,-1]
b2.sus=linvar([.1,2], start=Clock.mod(4))
b2.oct=[3,5,9]
b2.oct=7
b2.oct=var([2,9,3,8])
b2.dur=var([.125,.05,.5], PRand(1,8))
b2.dur=var([.125,.05,.5], PRand(1,8))
b2.amplify=linvar(P[.2]|PWhite(0,1.3), start=Clock.mod(4))
b2.degree = PRand(0,8)
b2.fade(fvol=2)

a4.fadeout(20)

dd.ampfadeout(64)
