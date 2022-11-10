#pragma once
#include "helpers.h"

#define NS_NAME(namespace, item) namespace##_##item
#define NSD(item) DEFER(NS_NAME, NAMESPACE, item)
#define NS(namespace, item) DEFER(NS_NAME, namespace, item)

