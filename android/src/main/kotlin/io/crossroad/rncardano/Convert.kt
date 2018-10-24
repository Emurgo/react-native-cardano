package io.crossroad.rncardano

import com.facebook.common.util.Hex
import com.facebook.react.bridge.*
import org.json.JSONArray
import org.json.JSONObject

object Convert {
    fun bytes(encodedString: String): ByteArray {
        return Hex.decodeHex(encodedString)
    }

    fun string(bytes: ByteArray): String {
        return Hex.encodeHex(bytes, false)
    }

    fun array(json: JSONArray): WritableArray {
        val array = Arguments.createArray()
        for (i in 0 until json.length()) {
            val obj = json[i]
            when (obj) {
                is Int -> array.pushInt(obj)
                is Boolean -> array.pushBoolean(obj)
                is Long -> array.pushDouble(obj.toDouble())
                is Float -> array.pushDouble(obj.toDouble())
                is Double -> array.pushDouble(obj.toDouble())
                is String -> array.pushString(obj)
                is JSONArray -> array.pushArray(this.array(obj))
                JSONObject.NULL -> array.pushNull()
                is JSONObject -> array.pushMap(this.map(obj))
            }
        }
        return array
    }

    fun map(json: JSONObject): WritableMap {
        val map = Arguments.createMap()
        for (key in json.keys()) {
            val obj = json[key]
            when (obj) {
                is Int -> map.putInt(key, obj)
                is Boolean -> map.putBoolean(key, obj)
                is Long -> map.putDouble(key, obj.toDouble())
                is Float -> map.putDouble(key, obj.toDouble())
                is Double -> map.putDouble(key, obj.toDouble())
                is String -> map.putString(key, obj)
                is JSONArray -> map.putArray(key, this.array(obj))
                JSONObject.NULL -> map.putNull(key)
                is JSONObject -> map.putMap(key, this.map(obj))
            }
        }
        return map
    }

    fun json(array: ReadableArray): JSONArray {
        val json = JSONArray()
        for (i in 0 until array.size()) {
            when (array.getType(i)) {
                ReadableType.Array -> json.put(this.json(array.getArray(i)))
                ReadableType.Map -> json.put(this.json(array.getMap(i)))
                ReadableType.Boolean -> json.put(array.getBoolean(i))
                ReadableType.Null, null -> json.put(JSONObject.NULL)
                ReadableType.Number -> json.put(array.getDouble(i))
                ReadableType.String -> json.put(array.getString(i))
            }
        }
        return json
    }

    fun json(map: ReadableMap): JSONObject {
        val json = JSONObject()
        val iterator = map.keySetIterator()
        var key: String? = if (iterator.hasNextKey()) { iterator.nextKey() } else { null }
        while (key != null) {
            when (map.getType(key)) {
                ReadableType.Array -> json.put(key, this.json(map.getArray(key)))
                ReadableType.Map -> json.put(key, this.json(map.getMap(key)))
                ReadableType.Boolean -> json.put(key, map.getBoolean(key))
                ReadableType.Null, null -> json.put(key, JSONObject.NULL)
                ReadableType.Number -> json.put(key, map.getDouble(key))
                ReadableType.String -> json.put(key, map.getString(key))
            }
            key = if (iterator.hasNextKey()) { iterator.nextKey() } else { null }
        }
        return json
    }

    fun bytes(array: ReadableArray): ByteArray {
        return ByteArray(array.size()) { array.getInt(it).toByte() }
    }


    @Throws
    private fun checkError(json: JSONObject) {
        if(json.getBoolean("failed")) {
            throw Throwable(
                    "Error in: " + json.getString("loc") +
                            ", message: " + json.getString("message")
            )
        }
    }

    fun result(json: JSONObject): WritableMap {
        this.checkError(json)
        return this.map(json.getJSONObject("result"))
    }

    fun arrayResult(json: JSONObject): WritableArray {
        this.checkError(json)
        return this.array(json.getJSONArray("result"))
    }

    fun boolResult(json: JSONObject): Boolean {
        this.checkError(json)
        return json.getBoolean("result")
    }
}