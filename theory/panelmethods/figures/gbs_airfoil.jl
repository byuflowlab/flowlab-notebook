import AirfoilParams
using Plots

###Data put into the function
r = 0.075
w = 25 #Wedge Angle
c = 12
TE = 0
xpos= 1/3
deg = 3
label1 = "Airfoil"
label2 = "Control Points"
label3 = "Camber Line"
color1 = :black
color2 = :black
color3 = :black

### ToDo
# line to indicate distance cp 2 and 6 are at 1/3l
# Thin line through cp3, 4, 5

#Possible camber line or TE camberline indication

knots, cp, Cwx, Cwz = AirfoilParams.gbs(r,c,w,[]; degree=deg)

ControlPolygon = cp[end-1:end,:]
int1 = trunc(Int, (length(cp)/6)-.5)
int2 = trunc(Int, int1+2)
NoseLine = cp[int1:int2,:]*2
OneThird = [0 0; 1/3 0]
OneThirdText = "1/3 Chord Length"

plot(Cwx, Cwz, lab = label1, foreground_color_grid = :white, foreground_color_axis = :white,
foreground_color_border = :white, foreground_color_legend = :white, linecolor = color1, ticks = false,
aspectratio=:equal,ylim=(findmin(Cwz)[1]-.2, findmax(Cwz)[1]+.2),linewidth = 2)
scatter!(cp[:,1],cp[:,2],lab=label2,markercolor=:white,markerstrokecolor = color2,markersize=5)
plot!(ControlPolygon[:,1],ControlPolygon[:,2],lab=label3,linestyle=:dash,linewidth=1.5,linecolor=color3)
plot!(NoseLine[:,1],NoseLine[:,2],linewidth=0.1,linecolor=:dimgray,lab="")
#plot!(OneThird[:,1],OneThird[:,2],linewidth=0.1,linecolor=:dimgray,lab="")
savefig("gbs.png")
