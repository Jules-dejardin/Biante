




a1 >> apad(
    P[0],
    dur=PRand(4, 8)[:16],
    oct=6,
)
# a1.span(srot(128), .8)
a1.fadeout(48)


a1.thick_thin=linvar([0,1,.4,.8,0,.6], PRand(2,24), start=Clock.mod(4))
a1.degree = P[0,4,-2] + P(0,4,5)

a1.space=linvar([0,1,.4,.8,0,.6],PRand(2,24), start=Clock.mod(4))

a1.detail=linvar([0,1,.4,.8,0,.6],PRand(2,24), start=Clock.mod(4))

Root.default = var([0,2,4], 1)


dd >> play("[XX..XX.X]", rate=linvar([4,8], 32, start=Clock.mod(4))).ampfadein()


dd.degree="<[**...***....***]><[--]>"
dd.ampfadeout(24)
dd.rate=linvar([.2,6],48)
dd.pan=PWhite(-1,1)

dd

dd.rate=1

b1 >> blip(degree=linvar([0,20], 48, start=Clock.mod(4)), oct=8, amp=PWhite(0,1), dur=.125)

b1.amp=[1,0,0,1,1,0,1,1,1,0,0]

b1.pan=[-1,1,0,1,0,-1]

b1.sus=linvar([.1,2], start=Clock.mod(4))

b1.oct=[3,5,,9]

a4.fadeout(20)



dd.ampfadeout(64)
