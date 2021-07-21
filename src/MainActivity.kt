package com.example.firstapp

import android.animation.ObjectAnimator
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.view.animation.*
import android.widget.ImageView
import android.widget.TextView
import androidx.constraintlayout.widget.ConstraintLayout

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val wheel = findViewById<ImageView>(R.id.wheel)
        val wheel_animation = ObjectAnimator.ofFloat(wheel, "rotation", 360f).apply {
            duration = 2000
            repeatCount = Animation.INFINITE
            interpolator = LinearInterpolator()
            start()
        }

        val lifebar = findViewById<TextView>(R.id.life)
        val scoreboard = findViewById<TextView>(R.id.score)

        lifebar.text = "5" // max chances/lives
        scoreboard.text = "0" // init score

        val main_act = findViewById<ConstraintLayout>(R.id.mainAct)
        main_act.setOnClickListener() {
            var life = Integer.parseInt(lifebar.text.toString())
            var score :Int

            val winOrLose : (String) -> Unit = { result ->
                scoreboard.text = result; scoreboard.textSize = 50f
                wheel_animation.cancel(); wheel.rotation = 0f
            }

            if (scoreboard.text == getString(R.string.on_lose) || scoreboard.text == getString(R.string.on_win)) {
                wheel_animation.start(); wheel_animation.duration = 2000
                lifebar.text = "5"; scoreboard.text = "0"; scoreboard.textSize = 70f
            } else {
                score = Integer.parseInt(scoreboard.text.toString())
                if (wheel.rotation <= 10f || wheel.rotation >= 350f) {
                    scoreboard.text = (++score).toString()
                    wheel_animation.duration -= 100

                    if (score >= 10) winOrLose(getString(R.string.on_win))
                } else {
                    lifebar.text = (--life).toString()

                    if (life <= 0) winOrLose(getString(R.string.on_lose))
                }
            }
        }
    }
}