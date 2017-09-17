package com.example.anomalydetection;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.Toast;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);


        final String token = SharedPrefManager.getInstance(this).getDeviceToken();
        Toast.makeText(MainActivity.this, token, Toast.LENGTH_SHORT).show();
    }
}
