from django.contrib import admin
from .models import EstimationHistory

@admin.register(EstimationHistory)
class EstimationHistoryAdmin(admin.ModelAdmin):
    list_display = ('region', 'layout', 'area', 'base_price', 'estimated_price', 'created_at')
    list_filter = ('region', 'floor_type', 'decoration', 'created_at')
    search_fields = ('region', 'layout')
