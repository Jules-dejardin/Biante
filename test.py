
highnap = SynthDef("highNap")
basss = SynthDef("bass")
bpfsaw = SynthDef("bpfsaw")

b1 >> highnap(0, dur=10, oct=2)
b1 >> bpfsaw(0, dur=1, oct=(3,4,5,6), atk=.1)

e1 >> epiano(dur=.5, rel=0, sus=linvar([.1,2],8))

e1.oct=[3,5,3,4]
e1.dur=1

e1.dur=var((PTri(20)+1)*0.05,.25)
e1.fmod=0

b1.stop()


k1 >> play("x.(.V).", dur=.25, sample=[0,1,0,2,0]).stop()
p1 >> play("-", dur=.25, sample=[0,1,0,2,0], amp=3)
p2 >> play(".(o.)(.([oo]o[.o])).", dur=.25, sample=[0,1,0,2,0])
p_all.stop()


unpetitplayer = Player()

rr >> epiano(dur=[.25,1,.25,2], oct=(3,7), room2=1, sus=1, amp=linvar([.2,1])) + P[0,P(0,3,P*(0,4))]

b1 >> blip([0,1,2], dur=[.25,1,2,.5], oct=3)

h2 >> play("----", dur=.25, rate=PWhite(.2,5), amp=4)


bb >> klank()

print(SynthDefs)
print(Samples)

h1 >> blip([0,2], dur=linvar([0.01,0.08]), oct=var([5,4,5,4,6],1), room2=.2) + (P[0,3,5]+P*(0,8))



### Session 1

g2 >> play("<X><...*><----=><k..>", dur=.25, rate=[1,2,3,1,2], pan=[-1,0,1,0,-1])
g2.ampfadein()

g2.ampfadeout()


rr >> play("[XXX]", dur=.5, sample=PRand(0,2), pan=var([-1,0,1,0],PRand(2,8)), rate=linvar([1,3],64, start=Clock.mod(4)))#.ampfadein(48)
rr.rate=0
rr.pan=0

jj >> play("[XXXXXXXXXXXXXXX]......", rate=[3,4,1,5,8,8,8]).stop().ampfadeout(famp=.2)

ui >> play("Y.[=].", sample="9").stop()

rr.ampfadeout(8)

jj.ampfadeout()

print("")

a3 >> blip([0], dur=.25, oct=linvar([6,9,7,5,8,4]), pan=linvar([-1,1],PRand(2,16)), sus=linvar([.25,8],PRand(4,16)), amp=PRand(0,1))

a3.ampfadeout()

k9 >> play('<b{.b[bb]b[bbbbb]}><[vv]>', rate=linvar([.1,2], 16)).ampfadein(32)#.stop()

k9.stop()


k8 >> play('[bb]', rate=.2).fadeout(16)

ii >> blip(amp=)

#######

p2 >> padarp(
    [0, 2, 7],
    dur=2/4,
    oct=[3,7,9,4,5,6],
    amp=.8,
    verb=0,
    delay=0,
    detune=0,
    expand=0,
    # vol=1.2,
)
# p2.span(srot(12), .5)
# p2.fadein(16, fvol=.4)
p2.detune=sinvar([0,1], PWhite(.2,3)[:16], start=Clock.mod(4)),
p2.expand=linvar([0, 1], 24, start=Clock.mod(4))

p2.fadeout()

p2.verb=linvar([0,1], [32], start=Clock.mod(4))

p2.delay=linvar([0,1], [64], start=Clock.mod(4))


a2 >> apad(0, oct=7, dur=5) + (-6, -12)

a2.oct=3
