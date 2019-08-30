using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraSnapMovement : MonoBehaviour
{
    void Awake()
    {
        m_initialPos = m_targetPos = transform.position;
    }

    void Update()
    {
        if(Input.GetKeyDown(KeyCode.RightArrow) || Input.GetKeyDown(KeyCode.D))
        {
            m_targetPos = transform.position + (transform.right * m_movementSeparation);
            transform.position = m_targetPos;
        }

        if (Input.GetKeyDown(KeyCode.LeftArrow) || Input.GetKeyDown(KeyCode.A))
        {
            m_targetPos = transform.position + (transform.right * m_movementSeparation * -1);
            transform.position = m_targetPos;
        }
    }

    [SerializeField] private float m_movementSeparation = 3.0f;

    private Vector3 m_initialPos, m_targetPos;
}
