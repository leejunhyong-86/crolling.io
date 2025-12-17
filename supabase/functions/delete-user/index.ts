// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment

import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { corsHeaders } from '../_shared/cors.ts'

Deno.serve(async (req) => {
  // CORS 처리
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Authorization 헤더에서 JWT 토큰 추출
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(
        JSON.stringify({ error: 'No authorization header' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    // Supabase Admin 클라이언트 생성
    const supabaseAdmin = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? '',
      {
        auth: {
          autoRefreshToken: false,
          persistSession: false
        }
      }
    )

    // 사용자 인증 클라이언트 생성 (사용자 ID 확인용)
    const supabaseUser = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? '',
      {
        global: {
          headers: { Authorization: authHeader }
        }
      }
    )

    // 현재 인증된 사용자 정보 가져오기
    const { data: { user }, error: userError } = await supabaseUser.auth.getUser()
    
    if (userError || !user) {
      return new Response(
        JSON.stringify({ error: 'Unauthorized' }),
        { status: 401, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    const userId = user.id

    // 사용자 관련 데이터 삭제 (RLS가 적용되지 않으므로 admin 클라이언트 사용)
    // 순서가 중요: 외래 키 제약조건 때문에 자식 테이블부터 삭제
    
    // 1. 리뷰 삭제
    await supabaseAdmin
      .from('reviews')
      .delete()
      .eq('captain_id', userId)
    
    // 2. 거래 내역 삭제
    await supabaseAdmin
      .from('trades')
      .delete()
      .eq('captain_id', userId)
    
    // 3. 조회 기록 삭제
    await supabaseAdmin
      .from('voyage_logs')
      .delete()
      .eq('captain_id', userId)
    
    // 4. 위시리스트 삭제
    await supabaseAdmin
      .from('treasure_maps')
      .delete()
      .eq('captain_id', userId)
    
    // 5. 장바구니 삭제
    await supabaseAdmin
      .from('cargo')
      .delete()
      .eq('captain_id', userId)
    
    // 6. 선장 프로필 삭제
    await supabaseAdmin
      .from('captains')
      .delete()
      .eq('id', userId)

    // 7. Auth 사용자 삭제 (admin 권한 필요)
    const { error: deleteError } = await supabaseAdmin.auth.admin.deleteUser(userId)
    
    if (deleteError) {
      console.error('Failed to delete auth user:', deleteError)
      return new Response(
        JSON.stringify({ error: 'Failed to delete user account' }),
        { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
      )
    }

    return new Response(
      JSON.stringify({ success: true, message: 'Account deleted successfully' }),
      { status: 200, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    console.error('Delete user error:', error)
    return new Response(
      JSON.stringify({ error: 'Internal server error' }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
