using Plots

let n_f = 150
    @gif for f in 1:1:n_f
        p = plot(legend=false, ratio=1, framestyle=:none)
        default(color=:black, xlim=(-10.3, 10.3), ylim=(-10.3, 10.3))
        # A = [1 2/n_f * f; 3/n_f * f 1+3/n_f * f]                          # B
        # A = [1+0.41/n_f * f 2.19/n_f * f; -2.19/n_f * f 1+0.41/n_f * f]   # SR
        A = [1 2/n_f * f; 2/n_f * f 1 + 3/n_f * f]

        for i in -10:1:10
            a1 = A * [-10; i]
            a2 = A * [10; i]
            plot!([a1[1], a2[1]], [a1[2], a2[2]])
            b1 = A * [i; -10]
            b2 = A * [i; 10]
            plot!([b1[1], b2[1]], [b1[2], b2[2]])
        end
        b1 = A * [0; 0]
        b2 = A * [-1; 2]
        plot!([b1[1], b2[1]], [b1[2], b2[2]], lw=3, color=:green)
        x1 = A * [-10; 0]
        x2 = A * [10; 0]
        plot!([x1[1], x2[1]], [x1[2], x2[2]], lw=2, arrow=true, color=:blue)
        y1 = A * [0; -10]
        y2 = A * [0; 10]
        plot!([y1[1], y2[1]], [y1[2], y2[2]], lw=2, arrow=true, color=:red)
    end
end