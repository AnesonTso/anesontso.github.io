using Plots
using LaTeXStrings

let p = plot(legend=false, ratio=1, framestyle=:semi)
    c1 = palette(:Paired_10)[2]
    c2 = palette(:Paired_10)[8]
    c3 = palette(:Paired_10)[4]

    c4 = palette(:Paired_10)[1]
    c5 = palette(:Paired_10)[7]

    default(lw=4, arrow=true)

    plot!([0, 1], [0, 2], color=c1)

    plot!([0, 0.6667], [0, 1.3334], color=c4)
    plot!([0, 3.3334], [0, 1.6667], color=c5)

    plot!([0.6667, 4], [1.3334, 3], color=c4, style=:dot)
    plot!([3.3334, 4], [1.6667, 3], color=c5, style=:dot)

    plot!([0, 2], [0, 1], color=c2)

    plot!([0, 4], [0, 3], color=c3)
    annotate!((1.5, 0.5, (L"\mathbf{b}_2", c2)), 
        (0.6, 1.8, (L"\mathbf{b}_1", c1)),
        (2.7, 1.1, (L"1.67\mathbf{b}_2", c5)),
        (0.2, 1.1, (L"0.67\mathbf{b}_1", c4))
        )
end



let p = plot(legend=false, ratio=1, framestyle=:semi)
    c1 = palette(:Paired_10)[2]
    c2 = palette(:Paired_10)[8]
    c3 = palette(:Paired_10)[4]

    c4 = palette(:Paired_10)[1]
    c5 = palette(:Paired_10)[7]

    default(lw=4, arrow=true)

    plot!([0, 2], [0, 4], color=c1)
    plot!([0, 1], [0, 2], color=c2)
    
    
    plot!([0, 4], [0, 3], color=c3)
    annotate!(
        (0.5, 1.5, L"\mathbf{b}_1", c2),
        (1.5, 3.5, L"\mathbf{b}_2", c1), 
        # (2.5, 1.4, L"\mathbf{\alpha}", c3)
    )
end



let p = plot(legend=false, ratio=1, framestyle=:origin)
    c1 = palette(:Paired_10)[2]
    c2 = palette(:Paired_10)[8]

    c3 = palette(:Paired_10)[4]

    c4 = palette(:Paired_10)[1]
    c5 = palette(:Paired_10)[7]

    default(lw=4, arrow=true)

    plot!([0, 1], [0, 2], color=c1)
    plot!([0, -1], [0, -2], color=c4)

    plot!([0, 4], [0, 2], color=c5)
    plot!([0, 2], [0, 1], color=c2)
    
    plot!([0, 3], [0, 0], color=c3)

    plot!([-1, 3], [-2, 0], color=c4, style=:dot, arrow=false)
    plot!([4, 3], [2, 0], color=c5, style=:dot, arrow=false)
    
    annotate!(
        (0.5, 1.5, L"\alpha_1", c1),
        (-0.7, -0.7, L"-\alpha_1", c4),
        (1.3, 1, L"\alpha_2", c2),
        (2.5, 1.6, L"2\alpha_2", c5),
        # (2.5, 1.4, L"\mathbf{\alpha}", c3)
    )
end


let p1 = plot(legend=false, ratio=1, framestyle=:origin)
    default(lw=4, arrow=true)

    c1 = palette(:Paired_10)[2]
    c2 = palette(:Paired_10)[8]

    plot!([0, -1], [0, 2], color=c1)
    plot!([0, 3], [0, 5], alpha=0.5, style=:dot, color=c2)

    p2 = plot(legend=false, ratio=1, framestyle=:origin, title="Rotation")
    default(lw=4, arrow=true)

    plot!([0, -1], [0, 2], color=c1)
    plot!([0, 3], [0, 5], alpha=0.5, style=:dot, color=c2)
    plot!([0, 1.15], [0, 1.92], style=:dot, color=c1)

    p3 = plot(legend=false, ratio=1, framestyle=:origin, title="Scaling")
    default(lw=4, arrow=true)

    plot!([0, -1], [0, 2], color=c1)
    plot!([0, 3], [0, 5], alpha=0.5, style=:dot, color=c2)
    plot!([0, 3], [0, 5], style=:dot, color=c1)

    plot(p1, p2, p3, layout=(1,3), size=(700, 300))
end