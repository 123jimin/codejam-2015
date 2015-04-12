Program Pancake
    Integer, Dimension(1:1010) :: P
    Integer :: Ti, T, D, Di, M, Mi, Bs, Mb
    read (*, *) T
    do Ti=1, T
        read (*, *) D
        read (*, *) P(1:D)
        M = maxval(P(1:D))
        Mb = M
        do Mi=1, M
            Bs = 0
            do Di=1, D
                if (mod(P(Di), Mi) == 0) then
                    Bs = Bs + (P(Di) / Mi)
                else
                    Bs = Bs + 1 + (P(Di) / Mi)
                end if
            end do
            Di = Bs + Mi - D
            if (Di < Mb) then
                Mb = Di
            end if
        end do
        write (*, "(A6, I0, A2, I0)") "Case #", Ti, ": ", Mb
    end do
End Program
