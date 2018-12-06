using Plots
# pyplot()

"""
    binomialcoeff(n, i)

Calculate the Binomial Coefficient defined as:

```math
\\binom{n}{i} = \\frac{n!}{i!(n-1)!}
```
"""
function binomialcoeff(n, i)
    return factorial(n)./(factorial(i).*factorial(n-i))
end

"""
    bernsteincoeff(u, n, i)

Calculate Bernstein Coefficient (Bezier Basis Function) defined as:

```math
B_{i, n}(u) = \\binom{n}{i} u^i (1-u)^{n-1}
```

at parametric point, \$u\$, where \$ 0 \\leq u \\leq 1 \$. \$u\$ may either be a single value or an array.

(see NURBS, eqn 1.8)
"""
function bernsteincoeff(u, n, i)
    return binomialcoeff(n, i) .* u.^i .* (1 .- u).^(n-i)
end

"""
    simple_bezier1D(P, u)

Calculate a point along a Bezier curve at the parametric point, \$u\$, based on the control points  \$\\mathbf{P}\$ where the Bezier curve, \$\\mathbf{C}(u)\$ is defined as:

```math
\\mathbf{C}(u) = \\sum_{i=0}^n B_{i, n}(u) \\mathbf{P}_i~, ~~~~ 0 \\leq u \\leq 1
```
where \$ B \$ is the basis (Bernstein Coefficient) at parametric point, \$u\$, as calculated from ```bernsteincoeff```, and n is the number of control points in vector \$\\mathbf{P}\$. Again, \$u\$ may either be a single value or an array.

(see NURBS eqn 1.7)
"""
function simple_bezier1D(P, u)
    n = length(P[:, 1])
    bc = zeros(length(u), n)

    for i=1:n
        bc[:, i] = bernsteincoeff(u, n, i)
    end

    C = bc*P

    return C
end


"""
    decasteljau_bezier1D(P, u)

Calculate a point along a Bezier curve at the parametric point, \$u_0\$, based on the control points \$\\mathbf{P}\$ using deCasteljau's Algorithm:

```math
\\mathbf{P}_{k, i}(u_0) = (1- u_0)\\mathbf{P}_{k-1, i}(u_0) + u_0 \\mathbf{P}_{k-1, i+1}(u_0)
```
for \$ k = 1, ..., n\$ and \$i = 0, ..., n-k\$, where \$u_0\$ is any single value from 0 to 1.

(see NURBS, eqn 1.12 and A1.5)
"""
function decasteljau_bezier1D(P, u)
    n = length(P[:, 1])
    Q = copy(P)
    for k=1:n
        for i=1:n-k
            Q[i, :] = (1-u)*Q[i, :] + u*Q[i+1, :]
        end
    end
    C = Q[1, :]

end

# ---- PLOTS FOR THEORY ----- #
u = collect(range(0,stop=1,length=50))

b04 = bernsteincoeff(u, 4, 0)
b14 = bernsteincoeff(u, 4, 1)
b24 = bernsteincoeff(u, 4, 2)
b34 = bernsteincoeff(u, 4, 3)
b44 = bernsteincoeff(u, 4, 4)

plot(legendfont=11,tickfont=11,xlabel="u",ylabel="\$B_{i,n}(u)\$")
plot!(u,b04,label="\$B_{0,4}\$")
plot!(u,b14,label="\$B_{1,4}\$")
plot!(u,b24,label="\$B_{2,4}\$")
plot!(u,b34,label="\$B_{3,4}\$")
plot!(u,b44,label="\$B_{4,4}\$")
savefig("bernstein.pdf")

#-- BUILDING PARAMETRIC CURVE:
#define some points
P0 = [0,0]
P1 = [1,1]
P2 = [2,0]

#Parametric Curve P(t)
function P(t,P0,P1)
  x = (1 .-t)*P0[1] .+ t.*P1[1]
  y = (1 .-t)*P0[2] .+ t.*P1[2]
  return x,y
end

x0,y0 = P(u,P0,P1)
x1,y1 = P(u,P1,P2)
x = [x0;x1]
y = [y0;y1]

#-- parameteric plot 1
plot(x0,y0,xlabel="u",legend=false,aspectratio=:equal)
scatter!([0.0, 1.0], [0.0, 1.0])
scatter!([-0.1, 0.9], [0.1, 1.1], markeralpha=0, markerstrokecolor=:transparent, series_annotations=[text("\$P_0\$",:left, 11), text("\$P_1\$",:left, 11)])
savefig("para1.pdf")


# -- parametric plot 2
p1=plot(x,y,xlabel="u",legend=false,aspectratio=:equal,tickfont=11)
scatter!([0.0, 1.0, 2.0], [0.0, 1.0, 0.0])
scatter!([-0.1, 1.0, 2.1], [0.1, 1.1, 0.1], markeralpha=0, markerstrokecolor=:transparent, series_annotations=[text("\$P_0\$",:left, 11), text("\$P_1\$", :left, 11), text("\$P_2\$",:left, 11)])

Q0 = P(0.25,P0,P1)
Q1 = P(0.25,P1,P2)
p2 = plot(x,y,xlabel="u",legend=false,aspectratio=:equal,tickfont=11)
scatter!([0.0, 1.0, 2.0], [0.0, 1.0, 0.0])
scatter!([-0.1, 1.0, 2.1], [0.1, 1.1, 0.1], markeralpha=0, markerstrokecolor=:transparent, series_annotations=[text("\$P_0\$",:left, 11), text("\$P_1\$", :left, 11), text("\$P_2\$",:left, 11)])
plot!([Q0[1], Q1[1]],[Q0[2], Q1[2]])
scatter!([Q0[1], Q1[1]],[Q0[2], Q1[2]])
scatter!([0.5],[0.375])
scatter!([-.075,1.3,0.5],[0.25,0.75,0.25], markeralpha=0, markerstrokecolor=:transparent, series_annotations=[text("\$P_{\\bar{01}}(0.25)\$",:left, 11), text("\$P_{\\bar{12}}(0.25)\$", :left, 11), text("\$Q(0.25)\$",:left, 11)])

Q0 = P(0.5,P0,P1)
Q1 = P(0.5,P1,P2)
p3 = plot(x,y,legend=false,aspectratio=:equal,tickfont=11)
scatter!([0.0, 1.0, 2.0], [0.0, 1.0, 0.0])
scatter!([-0.1, 1.0, 2.1], [0.1, 1.1, 0.1], markeralpha=0, markerstrokecolor=:transparent, series_annotations=[text("\$P_0\$",:left, 11), text("\$P_1\$", :left, 11), text("\$P_2\$",:left, 11)])
plot!([Q0[1], Q1[1]],[Q0[2], Q1[2]])
scatter!([Q0[1], Q1[1]],[Q0[2], Q1[2]])
scatter!([0.5,1.0],[0.375, 0.5])
scatter!([0.95],[0.35], markeralpha=0, markerstrokecolor=:transparent, series_annotations=[text("\$Q(0.5)\$", :left, 11)])


Q0 = P(0.75,P0,P1)
Q1 = P(0.75,P1,P2)
p4 = plot(x,y,legend=false,aspectratio=:equal,tickfont=11)
scatter!([0.0, 1.0, 2.0], [0.0, 1.0, 0.0])
scatter!([-0.1, 1.0, 2.1], [0.1, 1.1, 0.1], markeralpha=0, markerstrokecolor=:transparent, series_annotations=[text("\$P_0\$",:left, 11), text("\$P_1\$", :left, 11), text("\$P_2\$",:left, 11)])
plot!([Q0[1], Q1[1]],[Q0[2], Q1[2]])
scatter!([Q0[1], Q1[1]],[Q0[2], Q1[2]])
scatter!([0.5,1.0, 1.5],[0.375, 0.5, 0.375])
scatter!([1.375],[0.25], markeralpha=0, markerstrokecolor=:transparent, series_annotations=[text("\$Q(0.75)\$", :left, 11)])


plot(p1,p2,p3,p4, layout = 4,size=(1200,800))
savefig("para2.pdf")

#-- parameteric plot 3

function C(t,P0,P1,P2)
  x = (1 .-t.^2).*P0[1] + 2 .*t.*(1 .-t).*P1[1] + t.^2 .*P2[1]
  y = (1 .-t.^2).*P0[2] + 2 .*t.*(1 .-t).*P1[2] + t.^2 .*P2[2]
  return x, y
end

xc, yc = C(u,P0,P1,P2)

plot(x,y,xlabel="u",legend=false,aspectratio=:equal,tickfont=11)
plot!(xc,yc,annotate=[(0.95,0.4,text("C(u)",11))])
scatter!([0.0, 1.0, 2.0], [0.0, 1.0, 0.0])
scatter!([-0.1, 1.0, 2.1], [0.1, 1.1, 0.1], markeralpha=0, markerstrokecolor=:transparent, series_annotations=[text("\$P_0\$",:left, 11), text("\$P_1\$", :left, 11), text("\$P_2\$",:left, 11)])
savefig("para3.pdf")