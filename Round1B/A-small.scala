object Main {
	val cache:Array[Int] = new Array[Int](1000005)
	def reverse(s:String):String = {
		if(s.length < 2) return s;
		return reverse(s.tail) + s.head;
	}
	def getValue(num:Int):Int = {
		if(num < 10) return num;
		if(cache(num) > 0) return cache(num);
		cache(num) = Main.getValue(num-1)+1
		
		if(num % 10 == 0) return cache(num)

		val rnum:Int = reverse(num.toString).toInt
		if(rnum < num){
			val tmp:Int = Main.getValue(rnum)+1
			if(tmp < cache(num)) cache(num) = tmp
		}
		return cache(num)
	}
	def solve():String = {
		return Main.getValue(readInt()).toString
	}
	def main(args: Array[String]) {
		val i:Int = 0
		for(i <- 1 to 1000003){
			cache(i) = 0
		}
		val T:Int = readInt()
		val Ti:Int = 0
		for(Ti <- 1 to T) {
			println("Case #"+Ti+": "+Main.solve)
		}
	}
}
