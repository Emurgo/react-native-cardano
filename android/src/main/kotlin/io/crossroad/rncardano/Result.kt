package io.crossroad.rncardano

import com.facebook.react.bridge.Promise

class Result<T>(val value: T?, val error: String?) {
    companion object {
        fun <T>ok(value: T): Result<T> {
            return Result(value, null)
        }

        fun <T>error(err: String): Result<T> {
            return Result(null, err)
        }
    }

    fun <T2>map(mapper: (value: T) -> T2): Result<T2> {
        return if (this.value != null) {
            Result(mapper(this.value),null)
        } else {
            Result(null, this.error)
        }
    }

    fun <T2>mapNull(mapper: (value: T?) -> T2?): Result<T2> {
        return if (this.error == null) {
            Result(mapper(this.value), null)
        } else {
            Result(null, this.error)
        }
    }

    fun isOk(): Boolean {
        return this.error == null
    }

    fun isErr(): Boolean {
        return this.error != null
    }

    fun mapErr(mapper: (err: String) -> String): Result<T> {
        return if (this.error != null) {
            Result(null, mapper(this.error))
        } else {
            this
        }
    }

    fun pour(promise: Promise) {
        if (this.error != null) {
            promise.reject("0", this.error)
        } else {
            promise.resolve(this.value)
        }
    }
}