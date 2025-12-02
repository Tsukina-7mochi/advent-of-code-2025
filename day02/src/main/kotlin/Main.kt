import kotlin.math.sqrt

fun divisors(num: Int): Sequence<Int> = sequence {
    for (i in 1..(sqrt(num.toDouble()).toInt())) {
        if (num % i == 0) {
            yield(i)
            if (num / i != i) {
                yield(num / i)
            }
        }
    }
}

fun isInvalid(code: String): Boolean {
    for (len in divisors(code.length)) {
        if (len == code.length) continue

        val repeated = code.substring(0, len).repeat(code.length / len)
        if (repeated == code) return true
    }

    return false
}

fun main() {
    val sum = readln()
        .split(",")
        .map {
            val codes = it.split("-")
            Pair(codes[0].toLong(), codes[1].toLong())
        }
        .flatMap { it.first..it.second }
        .filter { isInvalid(it.toString()) }
        .sum()

    println(sum)
}
