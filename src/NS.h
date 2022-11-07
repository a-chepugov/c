#pragma once
#define EXPAND_TO(fn, ...) fn(__VA_ARGS__)

#define NS_NAME(namespace, item) namespace##_##item
#define NSD(item) EXPAND_TO(NS_NAME, NAMESPACE, item)
#define NS(namespace, item) EXPAND_TO(NS_NAME, namespace, item)

