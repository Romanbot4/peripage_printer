package com.romanbot4.peripage_printer

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.async
import kotlinx.coroutines.runBlocking
import java.nio.ByteBuffer


class PeripagePrinterPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var activity: Activity

    private lateinit var bluetoothHelper: BluetoothHelper
    private lateinit var bitmapHelper: BitmapHelper

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "peripage_printer")
        channel.setMethodCallHandler(this)
        this.context = flutterPluginBinding.applicationContext
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity
        bluetoothHelper = BluetoothHelper(this.activity, this.context)
        bitmapHelper = BitmapHelper(this.context)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        this.activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> result.success("Android ${android.os.Build.VERSION.RELEASE}")
            "isBluetoothOn" -> result.success(isBluetoothOn())
            "isBluetoothSupported" -> result.success(isBluetoothSupported())
            "turnOnBluetooth" -> result.success(turnOnBluetooth())
            "isPrinterConnected" -> result.success(isPrinterConnected())
            "connectPrinter" -> result.success(connectPrinter())
            "printFeed" -> {
                expectMapArguments(call)
                val lines: Int = call.argument<Any>("lines") as Int
                val isBlank: Boolean = call.argument<Any>("isBlank") as Boolean
                printFeed(lines = lines, isBlank = isBlank)
            }
            "checkAndRequestBluetoothPermission" -> {
                checkAndRequestBluetoothPermission()
                result.success("")
            }
            "findBluetoothDevices" -> {
                result.success(findBluetoothDevices())
            }
            "disconnectPrinter" -> result.success(disconnectPrinter())
            "printImage" -> {
                val bytes: ByteArray = call.argument<Any>("bitmap") as ByteArray
                val width: Int? = call.argument<Any>("width") as Int?
                val bitmap = BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
                return result.success(printImage(bitmap = bitmap, width = width))
            }
            "connectBluetoothDevice" -> {
                expectMapArguments(call)
                val address = call.argument<Any>("address") as String
                return result.success(connectBluetoothDeviceMacAddress(address))
            }
            "messageToBitmap" -> {
                val message: String = call.argument<Any>("message") as String
                val fontSize: Float = call.argument<Any>("fontSize") as Float
                return result.success(messageToBitmap(message, fontSize))
            }
            else -> result.notImplemented()
        }
    }

    @Throws(IllegalArgumentException::class)
    private fun expectMapArguments(call: MethodCall) {
        require(call.arguments is Map<*, *>) { "Map arguments expected" }
    }

    private fun isBluetoothOn(): Boolean {
        return bluetoothHelper.isBluetoothOn()
    }

    private fun isBluetoothSupported(): Boolean {
        return bluetoothHelper.isBluetoothSupported()
    }

    private fun turnOnBluetooth() {
        return bluetoothHelper.turnOnBluetooth()
    }

    private fun isPrinterConnected(): Boolean {
        return bluetoothHelper.isPrinterConnected()
    }

    private fun connectPrinter(): Boolean {
        return bluetoothHelper.connectPrinter()
    }

    private fun printFeed(lines: Int, isBlank: Boolean): Boolean {
        return runBlocking {
            val result = async {
                bluetoothHelper.printFeed(lines = lines, blank = isBlank)
            }
            result.await()
        }
    }

    private fun disconnectPrinter() {
        return bluetoothHelper.disconnectPrinter()
    }

    private fun printImage(bitmap: Bitmap, width: Int?) : Boolean {
        return runBlocking {
            val result = async {
                bluetoothHelper.printImage(bitmap, width = width)
            }
            result.await()
        }
    }

    private fun messageToBitmap(
        message: String,
        fontSize: Float = 20F,
    ): ByteArray {
        return runBlocking {
            val result = async {
                bluetoothHelper.messageToBitmap(message = message, fontSize = fontSize)
            }
            val bitmap = result.await()

            val size = bitmap.rowBytes * bitmap.height
            val byteBuffer = ByteBuffer.allocate(size)
            bitmap.copyPixelsToBuffer(byteBuffer)
            byteBuffer.array()
        }
    }

    @SuppressLint("MissingPermission", "NewApi")
    private fun findBluetoothDevices(): Iterable<HashMap<String, *>>? {
        val devices = bluetoothHelper.findBluetoothDevices() ?: return null

        return devices.map {
            hashMapOf(
                "name" to it.name,
                "address" to it.address,
                "alias" to it.alias,
                "bondState" to it.bondState,
                "type" to it.type,
            )
        }
    }

    private fun connectBluetoothDeviceMacAddress(macAddress: String) : Boolean{
        return bluetoothHelper.connectBluetoothDeviceMacAddress(macAddress)
    }

    private fun checkAndRequestBluetoothPermission() {
        bluetoothHelper.checkAndRequestBluetoothPermission()
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
