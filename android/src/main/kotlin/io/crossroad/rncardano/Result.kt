package io.crossroad.rncardano

import com.facebook.react.bridge.Promise

class Result(val value: Any?, val error: String?) {
    fun map(mapper: (value: Any) -> Any): Result {
        return if (this.value != null) {
            Result(mapper(this.value),null)
        } else {
            this
        }
    }

    fun mapErr(mapper: (err: String) -> String): Result {
        return if (this.error != null) {
            Result(null, mapper(this.error))
        } else {
            this
        }
    }

    fun finish(promise: Promise) {
        if (this.error != null) {
            promise.reject("0", this.error)
        } else {
            promise.resolve(this.value)
        }
    }
}

class ByteArrayResult(val value: ByteArray?, val error: String?) {
    fun map(mapper: (value: ByteArray) -> Any): Result {
        return if (this.value != null) {
            Result(mapper(this.value),null)
        } else {
            Result(null, this.error)
        }
    }
}