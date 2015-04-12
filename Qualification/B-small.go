package main
import (
	"container/heap"
	"fmt"
)

type IntHeap []int

func (h IntHeap) Len() int {return len(h)}
func (h IntHeap) Less(i, j int) bool {return h[i] > h[j]}
func (h IntHeap) Swap(i, j int) {h[i], h[j] = h[j], h[i]}

func (h *IntHeap) Push(x interface{}) {*h = append(*h, x.(int))}
func (h *IntHeap) Pop() interface{} {
	hh := *h
	n := len(hh)
	x := hh[n-1]
	*h = hh[0:n-1]
	return x
}

func getTime(h *IntHeap, mx int) int {
	if mx <= 0 {
		return 0
	}
	xt := heap.Pop(h)
	var x int = xt.(int)
	var minx int = x
	if x <= 3 {
		heap.Push(h, xt)
		return x
	}
	for xi := x/2; xi*4 >= x; xi-- {
		heap.Push(h, xi)
		heap.Push(h, x - xi)
		y := 1 + getTime(h, minx-2)
		for i := 0; i < len(*h); i++ {
			if (*h)[i] == xi {
				heap.Remove(h, i)
				break
			}
		}
		for i := 0; i < len(*h); i++ {
			if (*h)[i] == x-xi {
				heap.Remove(h, i)
				break
			}
		}
		if y < minx {
			minx = y
		}
	}
	heap.Push(h, xt)
	return minx
}

func main() {
	var T, D, P int
	fmt.Scanf("%d", &T)
	for Ti := 1; Ti <= T; Ti++ {
		h := &IntHeap{}
		heap.Init(h)
		fmt.Scanf("%d", &D)
		for Pi := 0; Pi < D; Pi++ {
			fmt.Scanf("%d", &P)
			heap.Push(h, P)
		}
		fmt.Printf("Case #%d: %d\n", Ti, getTime(h, (*h)[0]))
	}
}
