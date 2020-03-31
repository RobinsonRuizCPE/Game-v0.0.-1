using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Day_and_night_cycle : MonoBehaviour
{
    public float _speed = 1.0f;
    // Start is called before the first frame update
    void Start()
    {
    }

    // Update is called once per frame
    void Update()
    {
        this.transform.RotateAround(new Vector3(0, 0, 0), new Vector3(1, 0, 0), _speed);
    }
}
