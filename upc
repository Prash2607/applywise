package com.example.myapplication

import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import androidx.activity.enableEdgeToEdge
import androidx.appcompat.app.AppCompatActivity
import androidx.core.view.ViewCompat
import androidx.core.view.WindowInsetsCompat
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.firestore.FirebaseFirestore

class upc : AppCompatActivity() {
    private lateinit var auth: FirebaseAuth
    private lateinit var firestore: FirebaseFirestore

    // Initialize job card views list
    private lateinit var jobCardViews: List<JobCardView>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContentView(R.layout.activity_upc)

        ViewCompat.setOnApplyWindowInsetsListener(findViewById(R.id.main)) { v, insets ->
            val systemBars = insets.getInsets(WindowInsetsCompat.Type.systemBars())
            v.setPadding(systemBars.left, systemBars.top, systemBars.right, systemBars.bottom)
            insets
        }

        auth = FirebaseAuth.getInstance()
        firestore = FirebaseFirestore.getInstance()

        // Initialize back button
        val backButton = findViewById<Button>(R.id.buttonbackupc)
        backButton.setOnClickListener { finish() }

        // Initialize job card views
        jobCardViews = listOf(
            JobCardView(
                findViewById(R.id.etmrn_jb1_name),
                findViewById(R.id.etmrn_jb1_cmp),
                findViewById(R.id.etmrn_jb1_time),
                findViewById(R.id.etmrn_jb1_date),
                findViewById(R.id.etmrn_jb1_round),
                findViewById(R.id.etmrn_jb1_chance)
            ),
            JobCardView(
                findViewById(R.id.etmrn_jb2_name),
                findViewById(R.id.etmrn_jb2_cmp),
                findViewById(R.id.etmrn_jb2_time),
                findViewById(R.id.etmrn_jb2_date),
                findViewById(R.id.etmrn_jb2_round),
                findViewById(R.id.etmrn_jb2_chance)
            ),
            JobCardView(
                findViewById(R.id.etmrn_jb3_name),
                findViewById(R.id.etmrn_jb3_cmp),
                findViewById(R.id.etmrn_jb3_time),
                findViewById(R.id.etmrn_jb3_date),
                findViewById(R.id.etmrn_jb3_round),
                findViewById(R.id.etmrn_jb3_chance)
            ),
            JobCardView(
                findViewById(R.id.etmrn_jb4_name),
                findViewById(R.id.etmrn_jb4_cmp),
                findViewById(R.id.etmrn_jb4_time),
                findViewById(R.id.etmrn_jb4_date),
                findViewById(R.id.etmrn_jb4_round),
                findViewById(R.id.etmrn_jb4_chance)
            ),
            JobCardView(
                findViewById(R.id.etmrn_jb5_name),
                findViewById(R.id.etmrn_jb5_cmp),
                findViewById(R.id.etmrn_jb5_time),
                findViewById(R.id.etmrn_jb5_date),
                findViewById(R.id.etmrn_jb5_round),
                findViewById(R.id.etmrn_jb5_chance)
            )
        )

        // Fetch data if user is logged in
        val userId = auth.currentUser?.uid
        if (userId != null) {
            for (i in jobCardViews.indices) {
                val userJobId = "$userId${i + 1}" // Appending job number to user ID
                fetchJobData(userJobId, jobCardViews[i])
            }
        } else {
            Toast.makeText(this, "User not logged in", Toast.LENGTH_SHORT).show()
        }
    }

    private fun fetchJobData(userId: String, jobCardView: JobCardView) {
        firestore.collection("myjob").document(userId)
            .get()
            .addOnSuccessListener { document ->
                if (document.exists()) {
                    jobCardView.apply {
                        jobName.text = document.getString("jobName") ?: "N/A"
                        companyName.text = document.getString("companyName") ?: "N/A"
                        time.text = document.getString("time") ?: "N/A"
                        date.text = document.getString("date") ?: "N/A"
                        round.text = document.getString("round") ?: "N/A"
                        chance.text = document.getString("chance") ?: "N/A"
                    }
                } else {
                    Toast.makeText(this, "No job data found for ID: $userId", Toast.LENGTH_SHORT).show()
                }
            }
            .addOnFailureListener { exception ->
                Toast.makeText(this, "Error fetching data: ${exception.message}", Toast.LENGTH_SHORT).show()
            }
    }

    private data class JobCardView(
        val jobName: TextView,
        val companyName: TextView,
        val time: TextView,
        val date: TextView,
        val round: TextView,
        val chance: TextView
    )
}
