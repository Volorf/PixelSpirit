using System;
using UnityEngine;
using UnityEngine.EventSystems;

public class CardController: MonoBehaviour, IPointerEnterHandler, IPointerExitHandler
{
    [SerializeField] private RectTransform coverRect;
    [SerializeField] private RectTransform labelRect;

    [Header("Animation")] 
    [SerializeField] private float scaleFactor;

    private Vector3 _initialCoverScale;
    
    private Vector3 _initialLabelLocalPos;
    private Vector3 _labelOffset;

    private void Start()
    {
        _initialCoverScale = coverRect.localScale;
        _initialLabelLocalPos = labelRect.position;

        float h = labelRect.sizeDelta.y;
        _labelOffset = _initialLabelLocalPos + Vector3.up * h;
    }


    public void OnPointerEnter(PointerEventData eventData)
    {
    }

    public void OnPointerExit(PointerEventData eventData)
    {
    }
}
