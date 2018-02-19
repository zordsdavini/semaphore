PGDMP     3         	            v            mastodon_development    10.2    10.2 �   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            �           1262    60474    mastodon_development    DATABASE     �   CREATE DATABASE mastodon_development WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';
 $   DROP DATABASE mastodon_development;
             nolan    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             nolan    false                        0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  nolan    false    3                        3079    12544    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false                       0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                       1255    60475    timestamp_id(text)    FUNCTION     Y  CREATE FUNCTION timestamp_id(table_name text) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
  DECLARE
    time_part bigint;
    sequence_base bigint;
    tail bigint;
  BEGIN
    time_part := (
      -- Get the time in milliseconds
      ((date_part('epoch', now()) * 1000))::bigint
      -- And shift it over two bytes
      << 16);

    sequence_base := (
      'x' ||
      -- Take the first two bytes (four hex characters)
      substr(
        -- Of the MD5 hash of the data we documented
        md5(table_name ||
          '69283236cfae0066ef13109248240c43' ||
          time_part::text
        ),
        1, 4
      )
    -- And turn it into a bigint
    )::bit(16)::bigint;

    -- Finally, add our sequence number to our base, and chop
    -- it to the last two bytes
    tail := (
      (sequence_base + nextval(table_name || '_id_seq'))
      & 65535);

    -- Return the time part and the sequence part. OR appears
    -- faster here than addition, but they're equivalent:
    -- time_part has no trailing two bytes, and tail is only
    -- the last two bytes.
    RETURN time_part | tail;
  END
$$;
 4   DROP FUNCTION public.timestamp_id(table_name text);
       public       nolan    false    1    3            �            1259    60476    account_domain_blocks    TABLE     �   CREATE TABLE account_domain_blocks (
    id bigint NOT NULL,
    domain character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint
);
 )   DROP TABLE public.account_domain_blocks;
       public         nolan    false    3            �            1259    60482    account_domain_blocks_id_seq    SEQUENCE     ~   CREATE SEQUENCE account_domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public.account_domain_blocks_id_seq;
       public       nolan    false    3    196                       0    0    account_domain_blocks_id_seq    SEQUENCE OWNED BY     O   ALTER SEQUENCE account_domain_blocks_id_seq OWNED BY account_domain_blocks.id;
            public       nolan    false    197            �            1259    60484    account_moderation_notes    TABLE       CREATE TABLE account_moderation_notes (
    id bigint NOT NULL,
    content text NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 ,   DROP TABLE public.account_moderation_notes;
       public         nolan    false    3            �            1259    60490    account_moderation_notes_id_seq    SEQUENCE     �   CREATE SEQUENCE account_moderation_notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public.account_moderation_notes_id_seq;
       public       nolan    false    3    198                       0    0    account_moderation_notes_id_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE account_moderation_notes_id_seq OWNED BY account_moderation_notes.id;
            public       nolan    false    199            �            1259    60492    accounts    TABLE       CREATE TABLE accounts (
    id bigint NOT NULL,
    username character varying DEFAULT ''::character varying NOT NULL,
    domain character varying,
    secret character varying DEFAULT ''::character varying NOT NULL,
    private_key text,
    public_key text DEFAULT ''::text NOT NULL,
    remote_url character varying DEFAULT ''::character varying NOT NULL,
    salmon_url character varying DEFAULT ''::character varying NOT NULL,
    hub_url character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    note text DEFAULT ''::text NOT NULL,
    display_name character varying DEFAULT ''::character varying NOT NULL,
    uri character varying DEFAULT ''::character varying NOT NULL,
    url character varying,
    avatar_file_name character varying,
    avatar_content_type character varying,
    avatar_file_size integer,
    avatar_updated_at timestamp without time zone,
    header_file_name character varying,
    header_content_type character varying,
    header_file_size integer,
    header_updated_at timestamp without time zone,
    avatar_remote_url character varying,
    subscription_expires_at timestamp without time zone,
    silenced boolean DEFAULT false NOT NULL,
    suspended boolean DEFAULT false NOT NULL,
    locked boolean DEFAULT false NOT NULL,
    header_remote_url character varying DEFAULT ''::character varying NOT NULL,
    statuses_count integer DEFAULT 0 NOT NULL,
    followers_count integer DEFAULT 0 NOT NULL,
    following_count integer DEFAULT 0 NOT NULL,
    last_webfingered_at timestamp without time zone,
    inbox_url character varying DEFAULT ''::character varying NOT NULL,
    outbox_url character varying DEFAULT ''::character varying NOT NULL,
    shared_inbox_url character varying DEFAULT ''::character varying NOT NULL,
    followers_url character varying DEFAULT ''::character varying NOT NULL,
    protocol integer DEFAULT 0 NOT NULL,
    memorial boolean DEFAULT false NOT NULL,
    moved_to_account_id bigint
);
    DROP TABLE public.accounts;
       public         nolan    false    3            �            1259    60520    accounts_id_seq    SEQUENCE     q   CREATE SEQUENCE accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.accounts_id_seq;
       public       nolan    false    200    3                       0    0    accounts_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE accounts_id_seq OWNED BY accounts.id;
            public       nolan    false    201            �            1259    60522    admin_action_logs    TABLE     o  CREATE TABLE admin_action_logs (
    id bigint NOT NULL,
    account_id bigint,
    action character varying DEFAULT ''::character varying NOT NULL,
    target_type character varying,
    target_id bigint,
    recorded_changes text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 %   DROP TABLE public.admin_action_logs;
       public         nolan    false    3            �            1259    60530    admin_action_logs_id_seq    SEQUENCE     z   CREATE SEQUENCE admin_action_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.admin_action_logs_id_seq;
       public       nolan    false    202    3                       0    0    admin_action_logs_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE admin_action_logs_id_seq OWNED BY admin_action_logs.id;
            public       nolan    false    203            �            1259    60532    ar_internal_metadata    TABLE     �   CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 (   DROP TABLE public.ar_internal_metadata;
       public         nolan    false    3            �            1259    60538    blocks    TABLE     �   CREATE TABLE blocks (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL
);
    DROP TABLE public.blocks;
       public         nolan    false    3            �            1259    60541    blocks_id_seq    SEQUENCE     o   CREATE SEQUENCE blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.blocks_id_seq;
       public       nolan    false    3    205                       0    0    blocks_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE blocks_id_seq OWNED BY blocks.id;
            public       nolan    false    206            �            1259    60543    conversation_mutes    TABLE     �   CREATE TABLE conversation_mutes (
    id bigint NOT NULL,
    conversation_id bigint NOT NULL,
    account_id bigint NOT NULL
);
 &   DROP TABLE public.conversation_mutes;
       public         nolan    false    3            �            1259    60546    conversation_mutes_id_seq    SEQUENCE     {   CREATE SEQUENCE conversation_mutes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.conversation_mutes_id_seq;
       public       nolan    false    207    3                       0    0    conversation_mutes_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE conversation_mutes_id_seq OWNED BY conversation_mutes.id;
            public       nolan    false    208            �            1259    60548    conversations    TABLE     �   CREATE TABLE conversations (
    id bigint NOT NULL,
    uri character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 !   DROP TABLE public.conversations;
       public         nolan    false    3            �            1259    60554    conversations_id_seq    SEQUENCE     v   CREATE SEQUENCE conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.conversations_id_seq;
       public       nolan    false    3    209                       0    0    conversations_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE conversations_id_seq OWNED BY conversations.id;
            public       nolan    false    210            �            1259    60556    custom_emojis    TABLE     L  CREATE TABLE custom_emojis (
    id bigint NOT NULL,
    shortcode character varying DEFAULT ''::character varying NOT NULL,
    domain character varying,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    uri character varying,
    image_remote_url character varying,
    visible_in_picker boolean DEFAULT true NOT NULL
);
 !   DROP TABLE public.custom_emojis;
       public         nolan    false    3            �            1259    60565    custom_emojis_id_seq    SEQUENCE     v   CREATE SEQUENCE custom_emojis_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.custom_emojis_id_seq;
       public       nolan    false    3    211            	           0    0    custom_emojis_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE custom_emojis_id_seq OWNED BY custom_emojis.id;
            public       nolan    false    212            �            1259    60567    domain_blocks    TABLE     7  CREATE TABLE domain_blocks (
    id bigint NOT NULL,
    domain character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    severity integer DEFAULT 0,
    reject_media boolean DEFAULT false NOT NULL
);
 !   DROP TABLE public.domain_blocks;
       public         nolan    false    3            �            1259    60576    domain_blocks_id_seq    SEQUENCE     v   CREATE SEQUENCE domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.domain_blocks_id_seq;
       public       nolan    false    213    3            
           0    0    domain_blocks_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE domain_blocks_id_seq OWNED BY domain_blocks.id;
            public       nolan    false    214            �            1259    60578    email_domain_blocks    TABLE     �   CREATE TABLE email_domain_blocks (
    id bigint NOT NULL,
    domain character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 '   DROP TABLE public.email_domain_blocks;
       public         nolan    false    3            �            1259    60585    email_domain_blocks_id_seq    SEQUENCE     |   CREATE SEQUENCE email_domain_blocks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.email_domain_blocks_id_seq;
       public       nolan    false    215    3                       0    0    email_domain_blocks_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE email_domain_blocks_id_seq OWNED BY email_domain_blocks.id;
            public       nolan    false    216            �            1259    60587 
   favourites    TABLE     �   CREATE TABLE favourites (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    status_id bigint NOT NULL
);
    DROP TABLE public.favourites;
       public         nolan    false    3            �            1259    60590    favourites_id_seq    SEQUENCE     s   CREATE SEQUENCE favourites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.favourites_id_seq;
       public       nolan    false    3    217                       0    0    favourites_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE favourites_id_seq OWNED BY favourites.id;
            public       nolan    false    218            �            1259    60592    follow_requests    TABLE       CREATE TABLE follow_requests (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    show_reblogs boolean DEFAULT true NOT NULL
);
 #   DROP TABLE public.follow_requests;
       public         nolan    false    3            �            1259    60596    follow_requests_id_seq    SEQUENCE     x   CREATE SEQUENCE follow_requests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 -   DROP SEQUENCE public.follow_requests_id_seq;
       public       nolan    false    219    3                       0    0    follow_requests_id_seq    SEQUENCE OWNED BY     C   ALTER SEQUENCE follow_requests_id_seq OWNED BY follow_requests.id;
            public       nolan    false    220            �            1259    60598    follows    TABLE       CREATE TABLE follows (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    show_reblogs boolean DEFAULT true NOT NULL
);
    DROP TABLE public.follows;
       public         nolan    false    3            �            1259    60602    follows_id_seq    SEQUENCE     p   CREATE SEQUENCE follows_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.follows_id_seq;
       public       nolan    false    3    221                       0    0    follows_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE follows_id_seq OWNED BY follows.id;
            public       nolan    false    222            �            1259    60604    imports    TABLE     �  CREATE TABLE imports (
    id bigint NOT NULL,
    type integer NOT NULL,
    approved boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    data_file_name character varying,
    data_content_type character varying,
    data_file_size integer,
    data_updated_at timestamp without time zone,
    account_id bigint NOT NULL
);
    DROP TABLE public.imports;
       public         nolan    false    3            �            1259    60611    imports_id_seq    SEQUENCE     p   CREATE SEQUENCE imports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.imports_id_seq;
       public       nolan    false    3    223                       0    0    imports_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE imports_id_seq OWNED BY imports.id;
            public       nolan    false    224            �            1259    60613    invites    TABLE     Y  CREATE TABLE invites (
    id bigint NOT NULL,
    user_id bigint,
    code character varying DEFAULT ''::character varying NOT NULL,
    expires_at timestamp without time zone,
    max_uses integer,
    uses integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.invites;
       public         nolan    false    3            �            1259    60621    invites_id_seq    SEQUENCE     p   CREATE SEQUENCE invites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.invites_id_seq;
       public       nolan    false    225    3                       0    0    invites_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE invites_id_seq OWNED BY invites.id;
            public       nolan    false    226            �            1259    60623    list_accounts    TABLE     �   CREATE TABLE list_accounts (
    id bigint NOT NULL,
    list_id bigint NOT NULL,
    account_id bigint NOT NULL,
    follow_id bigint NOT NULL
);
 !   DROP TABLE public.list_accounts;
       public         nolan    false    3            �            1259    60626    list_accounts_id_seq    SEQUENCE     v   CREATE SEQUENCE list_accounts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.list_accounts_id_seq;
       public       nolan    false    3    227                       0    0    list_accounts_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE list_accounts_id_seq OWNED BY list_accounts.id;
            public       nolan    false    228            �            1259    60628    lists    TABLE     �   CREATE TABLE lists (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.lists;
       public         nolan    false    3            �            1259    60635    lists_id_seq    SEQUENCE     n   CREATE SEQUENCE lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.lists_id_seq;
       public       nolan    false    3    229                       0    0    lists_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE lists_id_seq OWNED BY lists.id;
            public       nolan    false    230            �            1259    60637    media_attachments    TABLE     '  CREATE TABLE media_attachments (
    id bigint NOT NULL,
    status_id bigint,
    file_file_name character varying,
    file_content_type character varying,
    file_file_size integer,
    file_updated_at timestamp without time zone,
    remote_url character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    shortcode character varying,
    type integer DEFAULT 0 NOT NULL,
    file_meta json,
    account_id bigint,
    description text
);
 %   DROP TABLE public.media_attachments;
       public         nolan    false    3            �            1259    60645    media_attachments_id_seq    SEQUENCE     z   CREATE SEQUENCE media_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.media_attachments_id_seq;
       public       nolan    false    3    231                       0    0    media_attachments_id_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE media_attachments_id_seq OWNED BY media_attachments.id;
            public       nolan    false    232            �            1259    60647    mentions    TABLE     �   CREATE TABLE mentions (
    id bigint NOT NULL,
    status_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint
);
    DROP TABLE public.mentions;
       public         nolan    false    3            �            1259    60650    mentions_id_seq    SEQUENCE     q   CREATE SEQUENCE mentions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.mentions_id_seq;
       public       nolan    false    3    233                       0    0    mentions_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE mentions_id_seq OWNED BY mentions.id;
            public       nolan    false    234            �            1259    60652    mutes    TABLE       CREATE TABLE mutes (
    id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    target_account_id bigint NOT NULL,
    hide_notifications boolean DEFAULT true NOT NULL
);
    DROP TABLE public.mutes;
       public         nolan    false    3            �            1259    60656    mutes_id_seq    SEQUENCE     n   CREATE SEQUENCE mutes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.mutes_id_seq;
       public       nolan    false    3    235                       0    0    mutes_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE mutes_id_seq OWNED BY mutes.id;
            public       nolan    false    236            �            1259    60658    notifications    TABLE       CREATE TABLE notifications (
    id bigint NOT NULL,
    activity_id bigint,
    activity_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint,
    from_account_id bigint
);
 !   DROP TABLE public.notifications;
       public         nolan    false    3            �            1259    60664    notifications_id_seq    SEQUENCE     v   CREATE SEQUENCE notifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.notifications_id_seq;
       public       nolan    false    3    237                       0    0    notifications_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE notifications_id_seq OWNED BY notifications.id;
            public       nolan    false    238            �            1259    60666    oauth_access_grants    TABLE     n  CREATE TABLE oauth_access_grants (
    id bigint NOT NULL,
    token character varying NOT NULL,
    expires_in integer NOT NULL,
    redirect_uri text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    revoked_at timestamp without time zone,
    scopes character varying,
    application_id bigint NOT NULL,
    resource_owner_id bigint NOT NULL
);
 '   DROP TABLE public.oauth_access_grants;
       public         nolan    false    3            �            1259    60672    oauth_access_grants_id_seq    SEQUENCE     |   CREATE SEQUENCE oauth_access_grants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.oauth_access_grants_id_seq;
       public       nolan    false    3    239                       0    0    oauth_access_grants_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE oauth_access_grants_id_seq OWNED BY oauth_access_grants.id;
            public       nolan    false    240            �            1259    60674    oauth_access_tokens    TABLE     X  CREATE TABLE oauth_access_tokens (
    id bigint NOT NULL,
    token character varying NOT NULL,
    refresh_token character varying,
    expires_in integer,
    revoked_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    scopes character varying,
    application_id bigint,
    resource_owner_id bigint
);
 '   DROP TABLE public.oauth_access_tokens;
       public         nolan    false    3            �            1259    60680    oauth_access_tokens_id_seq    SEQUENCE     |   CREATE SEQUENCE oauth_access_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.oauth_access_tokens_id_seq;
       public       nolan    false    3    241                       0    0    oauth_access_tokens_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE oauth_access_tokens_id_seq OWNED BY oauth_access_tokens.id;
            public       nolan    false    242            �            1259    60682    oauth_applications    TABLE     �  CREATE TABLE oauth_applications (
    id bigint NOT NULL,
    name character varying NOT NULL,
    uid character varying NOT NULL,
    secret character varying NOT NULL,
    redirect_uri text NOT NULL,
    scopes character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    superapp boolean DEFAULT false NOT NULL,
    website character varying,
    owner_type character varying,
    owner_id bigint
);
 &   DROP TABLE public.oauth_applications;
       public         nolan    false    3            �            1259    60690    oauth_applications_id_seq    SEQUENCE     {   CREATE SEQUENCE oauth_applications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.oauth_applications_id_seq;
       public       nolan    false    3    243                       0    0    oauth_applications_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE oauth_applications_id_seq OWNED BY oauth_applications.id;
            public       nolan    false    244            �            1259    60692    preview_cards    TABLE       CREATE TABLE preview_cards (
    id bigint NOT NULL,
    url character varying DEFAULT ''::character varying NOT NULL,
    title character varying DEFAULT ''::character varying NOT NULL,
    description character varying DEFAULT ''::character varying NOT NULL,
    image_file_name character varying,
    image_content_type character varying,
    image_file_size integer,
    image_updated_at timestamp without time zone,
    type integer DEFAULT 0 NOT NULL,
    html text DEFAULT ''::text NOT NULL,
    author_name character varying DEFAULT ''::character varying NOT NULL,
    author_url character varying DEFAULT ''::character varying NOT NULL,
    provider_name character varying DEFAULT ''::character varying NOT NULL,
    provider_url character varying DEFAULT ''::character varying NOT NULL,
    width integer DEFAULT 0 NOT NULL,
    height integer DEFAULT 0 NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    embed_url character varying DEFAULT ''::character varying NOT NULL
);
 !   DROP TABLE public.preview_cards;
       public         nolan    false    3            �            1259    60710    preview_cards_id_seq    SEQUENCE     v   CREATE SEQUENCE preview_cards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.preview_cards_id_seq;
       public       nolan    false    3    245                       0    0    preview_cards_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE preview_cards_id_seq OWNED BY preview_cards.id;
            public       nolan    false    246            �            1259    60712    preview_cards_statuses    TABLE     l   CREATE TABLE preview_cards_statuses (
    preview_card_id bigint NOT NULL,
    status_id bigint NOT NULL
);
 *   DROP TABLE public.preview_cards_statuses;
       public         nolan    false    3            �            1259    60715    reports    TABLE     �  CREATE TABLE reports (
    id bigint NOT NULL,
    status_ids bigint[] DEFAULT '{}'::bigint[] NOT NULL,
    comment text DEFAULT ''::text NOT NULL,
    action_taken boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    account_id bigint NOT NULL,
    action_taken_by_account_id bigint,
    target_account_id bigint NOT NULL
);
    DROP TABLE public.reports;
       public         nolan    false    3            �            1259    60724    reports_id_seq    SEQUENCE     p   CREATE SEQUENCE reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 %   DROP SEQUENCE public.reports_id_seq;
       public       nolan    false    3    248                       0    0    reports_id_seq    SEQUENCE OWNED BY     3   ALTER SEQUENCE reports_id_seq OWNED BY reports.id;
            public       nolan    false    249            �            1259    60726    schema_migrations    TABLE     K   CREATE TABLE schema_migrations (
    version character varying NOT NULL
);
 %   DROP TABLE public.schema_migrations;
       public         nolan    false    3            �            1259    60732    session_activations    TABLE     �  CREATE TABLE session_activations (
    id bigint NOT NULL,
    session_id character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_agent character varying DEFAULT ''::character varying NOT NULL,
    ip inet,
    access_token_id bigint,
    user_id bigint NOT NULL,
    web_push_subscription_id bigint
);
 '   DROP TABLE public.session_activations;
       public         nolan    false    3            �            1259    60739    session_activations_id_seq    SEQUENCE     |   CREATE SEQUENCE session_activations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 1   DROP SEQUENCE public.session_activations_id_seq;
       public       nolan    false    251    3                       0    0    session_activations_id_seq    SEQUENCE OWNED BY     K   ALTER SEQUENCE session_activations_id_seq OWNED BY session_activations.id;
            public       nolan    false    252            �            1259    60741    settings    TABLE     �   CREATE TABLE settings (
    id bigint NOT NULL,
    var character varying NOT NULL,
    value text,
    thing_type character varying,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    thing_id bigint
);
    DROP TABLE public.settings;
       public         nolan    false    3            �            1259    60747    settings_id_seq    SEQUENCE     q   CREATE SEQUENCE settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.settings_id_seq;
       public       nolan    false    3    253                       0    0    settings_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE settings_id_seq OWNED BY settings.id;
            public       nolan    false    254            �            1259    60749    site_uploads    TABLE     �  CREATE TABLE site_uploads (
    id bigint NOT NULL,
    var character varying DEFAULT ''::character varying NOT NULL,
    file_file_name character varying,
    file_content_type character varying,
    file_file_size integer,
    file_updated_at timestamp without time zone,
    meta json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
     DROP TABLE public.site_uploads;
       public         nolan    false    3                        1259    60756    site_uploads_id_seq    SEQUENCE     u   CREATE SEQUENCE site_uploads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.site_uploads_id_seq;
       public       nolan    false    3    255                       0    0    site_uploads_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE site_uploads_id_seq OWNED BY site_uploads.id;
            public       nolan    false    256                       1259    60758    status_pins    TABLE     �   CREATE TABLE status_pins (
    id bigint NOT NULL,
    account_id bigint NOT NULL,
    status_id bigint NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.status_pins;
       public         nolan    false    3                       1259    60763    status_pins_id_seq    SEQUENCE     t   CREATE SEQUENCE status_pins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.status_pins_id_seq;
       public       nolan    false    3    257                       0    0    status_pins_id_seq    SEQUENCE OWNED BY     ;   ALTER SEQUENCE status_pins_id_seq OWNED BY status_pins.id;
            public       nolan    false    258                       1259    60765    statuses    TABLE       CREATE TABLE statuses (
    id bigint DEFAULT timestamp_id('statuses'::text) NOT NULL,
    uri character varying,
    text text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    in_reply_to_id bigint,
    reblog_of_id bigint,
    url character varying,
    sensitive boolean DEFAULT false NOT NULL,
    visibility integer DEFAULT 0 NOT NULL,
    spoiler_text text DEFAULT ''::text NOT NULL,
    reply boolean DEFAULT false NOT NULL,
    favourites_count integer DEFAULT 0 NOT NULL,
    reblogs_count integer DEFAULT 0 NOT NULL,
    language character varying,
    conversation_id bigint,
    local boolean,
    account_id bigint NOT NULL,
    application_id bigint,
    in_reply_to_account_id bigint
);
    DROP TABLE public.statuses;
       public         nolan    false    279    3                       1259    60779    statuses_id_seq    SEQUENCE     q   CREATE SEQUENCE statuses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.statuses_id_seq;
       public       nolan    false    3                       1259    60781    statuses_tags    TABLE     Z   CREATE TABLE statuses_tags (
    status_id bigint NOT NULL,
    tag_id bigint NOT NULL
);
 !   DROP TABLE public.statuses_tags;
       public         nolan    false    3                       1259    60784    stream_entries    TABLE     !  CREATE TABLE stream_entries (
    id bigint NOT NULL,
    activity_id bigint,
    activity_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    hidden boolean DEFAULT false NOT NULL,
    account_id bigint
);
 "   DROP TABLE public.stream_entries;
       public         nolan    false    3                       1259    60791    stream_entries_id_seq    SEQUENCE     w   CREATE SEQUENCE stream_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.stream_entries_id_seq;
       public       nolan    false    3    262                        0    0    stream_entries_id_seq    SEQUENCE OWNED BY     A   ALTER SEQUENCE stream_entries_id_seq OWNED BY stream_entries.id;
            public       nolan    false    263                       1259    60793    subscriptions    TABLE     �  CREATE TABLE subscriptions (
    id bigint NOT NULL,
    callback_url character varying DEFAULT ''::character varying NOT NULL,
    secret character varying,
    expires_at timestamp without time zone,
    confirmed boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    last_successful_delivery_at timestamp without time zone,
    domain character varying,
    account_id bigint NOT NULL
);
 !   DROP TABLE public.subscriptions;
       public         nolan    false    3            	           1259    60801    subscriptions_id_seq    SEQUENCE     v   CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.subscriptions_id_seq;
       public       nolan    false    3    264            !           0    0    subscriptions_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;
            public       nolan    false    265            
           1259    60803    tags    TABLE     �   CREATE TABLE tags (
    id bigint NOT NULL,
    name character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
    DROP TABLE public.tags;
       public         nolan    false    3                       1259    60810    tags_id_seq    SEQUENCE     m   CREATE SEQUENCE tags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 "   DROP SEQUENCE public.tags_id_seq;
       public       nolan    false    3    266            "           0    0    tags_id_seq    SEQUENCE OWNED BY     -   ALTER SEQUENCE tags_id_seq OWNED BY tags.id;
            public       nolan    false    267                       1259    60812    users    TABLE     �  CREATE TABLE users (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    admin boolean DEFAULT false NOT NULL,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    locale character varying,
    encrypted_otp_secret character varying,
    encrypted_otp_secret_iv character varying,
    encrypted_otp_secret_salt character varying,
    consumed_timestep integer,
    otp_required_for_login boolean DEFAULT false NOT NULL,
    last_emailed_at timestamp without time zone,
    otp_backup_codes character varying[],
    filtered_languages character varying[] DEFAULT '{}'::character varying[] NOT NULL,
    account_id bigint NOT NULL,
    disabled boolean DEFAULT false NOT NULL,
    moderator boolean DEFAULT false NOT NULL,
    invite_id bigint
);
    DROP TABLE public.users;
       public         nolan    false    3                       1259    60826    users_id_seq    SEQUENCE     n   CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.users_id_seq;
       public       nolan    false    3    268            #           0    0    users_id_seq    SEQUENCE OWNED BY     /   ALTER SEQUENCE users_id_seq OWNED BY users.id;
            public       nolan    false    269                       1259    60828    web_push_subscriptions    TABLE     6  CREATE TABLE web_push_subscriptions (
    id bigint NOT NULL,
    endpoint character varying NOT NULL,
    key_p256dh character varying NOT NULL,
    key_auth character varying NOT NULL,
    data json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);
 *   DROP TABLE public.web_push_subscriptions;
       public         nolan    false    3                       1259    60834    web_push_subscriptions_id_seq    SEQUENCE        CREATE SEQUENCE web_push_subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.web_push_subscriptions_id_seq;
       public       nolan    false    3    270            $           0    0    web_push_subscriptions_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE web_push_subscriptions_id_seq OWNED BY web_push_subscriptions.id;
            public       nolan    false    271                       1259    60836    web_settings    TABLE     �   CREATE TABLE web_settings (
    id bigint NOT NULL,
    data json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    user_id bigint
);
     DROP TABLE public.web_settings;
       public         nolan    false    3                       1259    60842    web_settings_id_seq    SEQUENCE     u   CREATE SEQUENCE web_settings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 *   DROP SEQUENCE public.web_settings_id_seq;
       public       nolan    false    272    3            %           0    0    web_settings_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE web_settings_id_seq OWNED BY web_settings.id;
            public       nolan    false    273            �	           2604    60844    account_domain_blocks id    DEFAULT     v   ALTER TABLE ONLY account_domain_blocks ALTER COLUMN id SET DEFAULT nextval('account_domain_blocks_id_seq'::regclass);
 G   ALTER TABLE public.account_domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    197    196            �	           2604    60845    account_moderation_notes id    DEFAULT     |   ALTER TABLE ONLY account_moderation_notes ALTER COLUMN id SET DEFAULT nextval('account_moderation_notes_id_seq'::regclass);
 J   ALTER TABLE public.account_moderation_notes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    199    198            
           2604    60846    accounts id    DEFAULT     \   ALTER TABLE ONLY accounts ALTER COLUMN id SET DEFAULT nextval('accounts_id_seq'::regclass);
 :   ALTER TABLE public.accounts ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    201    200            
           2604    60847    admin_action_logs id    DEFAULT     n   ALTER TABLE ONLY admin_action_logs ALTER COLUMN id SET DEFAULT nextval('admin_action_logs_id_seq'::regclass);
 C   ALTER TABLE public.admin_action_logs ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    203    202            
           2604    60848 	   blocks id    DEFAULT     X   ALTER TABLE ONLY blocks ALTER COLUMN id SET DEFAULT nextval('blocks_id_seq'::regclass);
 8   ALTER TABLE public.blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    206    205            
           2604    60849    conversation_mutes id    DEFAULT     p   ALTER TABLE ONLY conversation_mutes ALTER COLUMN id SET DEFAULT nextval('conversation_mutes_id_seq'::regclass);
 D   ALTER TABLE public.conversation_mutes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    208    207            
           2604    60850    conversations id    DEFAULT     f   ALTER TABLE ONLY conversations ALTER COLUMN id SET DEFAULT nextval('conversations_id_seq'::regclass);
 ?   ALTER TABLE public.conversations ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    210    209            
           2604    60851    custom_emojis id    DEFAULT     f   ALTER TABLE ONLY custom_emojis ALTER COLUMN id SET DEFAULT nextval('custom_emojis_id_seq'::regclass);
 ?   ALTER TABLE public.custom_emojis ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    212    211            
           2604    60852    domain_blocks id    DEFAULT     f   ALTER TABLE ONLY domain_blocks ALTER COLUMN id SET DEFAULT nextval('domain_blocks_id_seq'::regclass);
 ?   ALTER TABLE public.domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    214    213             
           2604    60853    email_domain_blocks id    DEFAULT     r   ALTER TABLE ONLY email_domain_blocks ALTER COLUMN id SET DEFAULT nextval('email_domain_blocks_id_seq'::regclass);
 E   ALTER TABLE public.email_domain_blocks ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    216    215            !
           2604    60854    favourites id    DEFAULT     `   ALTER TABLE ONLY favourites ALTER COLUMN id SET DEFAULT nextval('favourites_id_seq'::regclass);
 <   ALTER TABLE public.favourites ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    218    217            #
           2604    60855    follow_requests id    DEFAULT     j   ALTER TABLE ONLY follow_requests ALTER COLUMN id SET DEFAULT nextval('follow_requests_id_seq'::regclass);
 A   ALTER TABLE public.follow_requests ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    220    219            %
           2604    60856 
   follows id    DEFAULT     Z   ALTER TABLE ONLY follows ALTER COLUMN id SET DEFAULT nextval('follows_id_seq'::regclass);
 9   ALTER TABLE public.follows ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    222    221            '
           2604    60857 
   imports id    DEFAULT     Z   ALTER TABLE ONLY imports ALTER COLUMN id SET DEFAULT nextval('imports_id_seq'::regclass);
 9   ALTER TABLE public.imports ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    224    223            *
           2604    60858 
   invites id    DEFAULT     Z   ALTER TABLE ONLY invites ALTER COLUMN id SET DEFAULT nextval('invites_id_seq'::regclass);
 9   ALTER TABLE public.invites ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    226    225            +
           2604    60859    list_accounts id    DEFAULT     f   ALTER TABLE ONLY list_accounts ALTER COLUMN id SET DEFAULT nextval('list_accounts_id_seq'::regclass);
 ?   ALTER TABLE public.list_accounts ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    228    227            -
           2604    60860    lists id    DEFAULT     V   ALTER TABLE ONLY lists ALTER COLUMN id SET DEFAULT nextval('lists_id_seq'::regclass);
 7   ALTER TABLE public.lists ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    230    229            0
           2604    60861    media_attachments id    DEFAULT     n   ALTER TABLE ONLY media_attachments ALTER COLUMN id SET DEFAULT nextval('media_attachments_id_seq'::regclass);
 C   ALTER TABLE public.media_attachments ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    232    231            1
           2604    60862    mentions id    DEFAULT     \   ALTER TABLE ONLY mentions ALTER COLUMN id SET DEFAULT nextval('mentions_id_seq'::regclass);
 :   ALTER TABLE public.mentions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    234    233            3
           2604    60863    mutes id    DEFAULT     V   ALTER TABLE ONLY mutes ALTER COLUMN id SET DEFAULT nextval('mutes_id_seq'::regclass);
 7   ALTER TABLE public.mutes ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    236    235            4
           2604    60864    notifications id    DEFAULT     f   ALTER TABLE ONLY notifications ALTER COLUMN id SET DEFAULT nextval('notifications_id_seq'::regclass);
 ?   ALTER TABLE public.notifications ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    238    237            5
           2604    60865    oauth_access_grants id    DEFAULT     r   ALTER TABLE ONLY oauth_access_grants ALTER COLUMN id SET DEFAULT nextval('oauth_access_grants_id_seq'::regclass);
 E   ALTER TABLE public.oauth_access_grants ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    240    239            6
           2604    60866    oauth_access_tokens id    DEFAULT     r   ALTER TABLE ONLY oauth_access_tokens ALTER COLUMN id SET DEFAULT nextval('oauth_access_tokens_id_seq'::regclass);
 E   ALTER TABLE public.oauth_access_tokens ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    242    241            9
           2604    60867    oauth_applications id    DEFAULT     p   ALTER TABLE ONLY oauth_applications ALTER COLUMN id SET DEFAULT nextval('oauth_applications_id_seq'::regclass);
 D   ALTER TABLE public.oauth_applications ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    244    243            F
           2604    60868    preview_cards id    DEFAULT     f   ALTER TABLE ONLY preview_cards ALTER COLUMN id SET DEFAULT nextval('preview_cards_id_seq'::regclass);
 ?   ALTER TABLE public.preview_cards ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    246    245            J
           2604    60869 
   reports id    DEFAULT     Z   ALTER TABLE ONLY reports ALTER COLUMN id SET DEFAULT nextval('reports_id_seq'::regclass);
 9   ALTER TABLE public.reports ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    249    248            L
           2604    60870    session_activations id    DEFAULT     r   ALTER TABLE ONLY session_activations ALTER COLUMN id SET DEFAULT nextval('session_activations_id_seq'::regclass);
 E   ALTER TABLE public.session_activations ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    252    251            M
           2604    60871    settings id    DEFAULT     \   ALTER TABLE ONLY settings ALTER COLUMN id SET DEFAULT nextval('settings_id_seq'::regclass);
 :   ALTER TABLE public.settings ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    254    253            O
           2604    60872    site_uploads id    DEFAULT     d   ALTER TABLE ONLY site_uploads ALTER COLUMN id SET DEFAULT nextval('site_uploads_id_seq'::regclass);
 >   ALTER TABLE public.site_uploads ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    256    255            R
           2604    60873    status_pins id    DEFAULT     b   ALTER TABLE ONLY status_pins ALTER COLUMN id SET DEFAULT nextval('status_pins_id_seq'::regclass);
 =   ALTER TABLE public.status_pins ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    258    257            \
           2604    60874    stream_entries id    DEFAULT     h   ALTER TABLE ONLY stream_entries ALTER COLUMN id SET DEFAULT nextval('stream_entries_id_seq'::regclass);
 @   ALTER TABLE public.stream_entries ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    263    262            _
           2604    60875    subscriptions id    DEFAULT     f   ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);
 ?   ALTER TABLE public.subscriptions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    265    264            a
           2604    60876    tags id    DEFAULT     T   ALTER TABLE ONLY tags ALTER COLUMN id SET DEFAULT nextval('tags_id_seq'::regclass);
 6   ALTER TABLE public.tags ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    267    266            j
           2604    60877    users id    DEFAULT     V   ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);
 7   ALTER TABLE public.users ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    269    268            k
           2604    60878    web_push_subscriptions id    DEFAULT     x   ALTER TABLE ONLY web_push_subscriptions ALTER COLUMN id SET DEFAULT nextval('web_push_subscriptions_id_seq'::regclass);
 H   ALTER TABLE public.web_push_subscriptions ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    271    270            l
           2604    60879    web_settings id    DEFAULT     d   ALTER TABLE ONLY web_settings ALTER COLUMN id SET DEFAULT nextval('web_settings_id_seq'::regclass);
 >   ALTER TABLE public.web_settings ALTER COLUMN id DROP DEFAULT;
       public       nolan    false    273    272            �          0    60476    account_domain_blocks 
   TABLE DATA               X   COPY account_domain_blocks (id, domain, created_at, updated_at, account_id) FROM stdin;
    public       nolan    false    196   ��      �          0    60484    account_moderation_notes 
   TABLE DATA               o   COPY account_moderation_notes (id, content, account_id, target_account_id, created_at, updated_at) FROM stdin;
    public       nolan    false    198   �      �          0    60492    accounts 
   TABLE DATA               E  COPY accounts (id, username, domain, secret, private_key, public_key, remote_url, salmon_url, hub_url, created_at, updated_at, note, display_name, uri, url, avatar_file_name, avatar_content_type, avatar_file_size, avatar_updated_at, header_file_name, header_content_type, header_file_size, header_updated_at, avatar_remote_url, subscription_expires_at, silenced, suspended, locked, header_remote_url, statuses_count, followers_count, following_count, last_webfingered_at, inbox_url, outbox_url, shared_inbox_url, followers_url, protocol, memorial, moved_to_account_id) FROM stdin;
    public       nolan    false    200   !�      �          0    60522    admin_action_logs 
   TABLE DATA               ~   COPY admin_action_logs (id, account_id, action, target_type, target_id, recorded_changes, created_at, updated_at) FROM stdin;
    public       nolan    false    202   F      �          0    60532    ar_internal_metadata 
   TABLE DATA               K   COPY ar_internal_metadata (key, value, created_at, updated_at) FROM stdin;
    public       nolan    false    204   c      �          0    60538    blocks 
   TABLE DATA               T   COPY blocks (id, created_at, updated_at, account_id, target_account_id) FROM stdin;
    public       nolan    false    205   �      �          0    60543    conversation_mutes 
   TABLE DATA               F   COPY conversation_mutes (id, conversation_id, account_id) FROM stdin;
    public       nolan    false    207   �      �          0    60548    conversations 
   TABLE DATA               A   COPY conversations (id, uri, created_at, updated_at) FROM stdin;
    public       nolan    false    209   �      �          0    60556    custom_emojis 
   TABLE DATA               �   COPY custom_emojis (id, shortcode, domain, image_file_name, image_content_type, image_file_size, image_updated_at, created_at, updated_at, disabled, uri, image_remote_url, visible_in_picker) FROM stdin;
    public       nolan    false    211   p      �          0    60567    domain_blocks 
   TABLE DATA               \   COPY domain_blocks (id, domain, created_at, updated_at, severity, reject_media) FROM stdin;
    public       nolan    false    213   �      �          0    60578    email_domain_blocks 
   TABLE DATA               J   COPY email_domain_blocks (id, domain, created_at, updated_at) FROM stdin;
    public       nolan    false    215   �      �          0    60587 
   favourites 
   TABLE DATA               P   COPY favourites (id, created_at, updated_at, account_id, status_id) FROM stdin;
    public       nolan    false    217   �      �          0    60592    follow_requests 
   TABLE DATA               k   COPY follow_requests (id, created_at, updated_at, account_id, target_account_id, show_reblogs) FROM stdin;
    public       nolan    false    219   �      �          0    60598    follows 
   TABLE DATA               c   COPY follows (id, created_at, updated_at, account_id, target_account_id, show_reblogs) FROM stdin;
    public       nolan    false    221   �      �          0    60604    imports 
   TABLE DATA               �   COPY imports (id, type, approved, created_at, updated_at, data_file_name, data_content_type, data_file_size, data_updated_at, account_id) FROM stdin;
    public       nolan    false    223          �          0    60613    invites 
   TABLE DATA               a   COPY invites (id, user_id, code, expires_at, max_uses, uses, created_at, updated_at) FROM stdin;
    public       nolan    false    225   =      �          0    60623    list_accounts 
   TABLE DATA               D   COPY list_accounts (id, list_id, account_id, follow_id) FROM stdin;
    public       nolan    false    227   Z      �          0    60628    lists 
   TABLE DATA               G   COPY lists (id, account_id, title, created_at, updated_at) FROM stdin;
    public       nolan    false    229   w      �          0    60637    media_attachments 
   TABLE DATA               �   COPY media_attachments (id, status_id, file_file_name, file_content_type, file_file_size, file_updated_at, remote_url, created_at, updated_at, shortcode, type, file_meta, account_id, description) FROM stdin;
    public       nolan    false    231   �      �          0    60647    mentions 
   TABLE DATA               N   COPY mentions (id, status_id, created_at, updated_at, account_id) FROM stdin;
    public       nolan    false    233   @      �          0    60652    mutes 
   TABLE DATA               g   COPY mutes (id, created_at, updated_at, account_id, target_account_id, hide_notifications) FROM stdin;
    public       nolan    false    235   �      �          0    60658    notifications 
   TABLE DATA               u   COPY notifications (id, activity_id, activity_type, created_at, updated_at, account_id, from_account_id) FROM stdin;
    public       nolan    false    237         �          0    60666    oauth_access_grants 
   TABLE DATA               �   COPY oauth_access_grants (id, token, expires_in, redirect_uri, created_at, revoked_at, scopes, application_id, resource_owner_id) FROM stdin;
    public       nolan    false    239   �      �          0    60674    oauth_access_tokens 
   TABLE DATA               �   COPY oauth_access_tokens (id, token, refresh_token, expires_in, revoked_at, created_at, scopes, application_id, resource_owner_id) FROM stdin;
    public       nolan    false    241   v;      �          0    60682    oauth_applications 
   TABLE DATA               �   COPY oauth_applications (id, name, uid, secret, redirect_uri, scopes, created_at, updated_at, superapp, website, owner_type, owner_id) FROM stdin;
    public       nolan    false    243   L`      �          0    60692    preview_cards 
   TABLE DATA               �   COPY preview_cards (id, url, title, description, image_file_name, image_content_type, image_file_size, image_updated_at, type, html, author_name, author_url, provider_name, provider_url, width, height, created_at, updated_at, embed_url) FROM stdin;
    public       nolan    false    245   ڭ      �          0    60712    preview_cards_statuses 
   TABLE DATA               E   COPY preview_cards_statuses (preview_card_id, status_id) FROM stdin;
    public       nolan    false    247   ��      �          0    60715    reports 
   TABLE DATA               �   COPY reports (id, status_ids, comment, action_taken, created_at, updated_at, account_id, action_taken_by_account_id, target_account_id) FROM stdin;
    public       nolan    false    248   �      �          0    60726    schema_migrations 
   TABLE DATA               -   COPY schema_migrations (version) FROM stdin;
    public       nolan    false    250   1�      �          0    60732    session_activations 
   TABLE DATA               �   COPY session_activations (id, session_id, created_at, updated_at, user_agent, ip, access_token_id, user_id, web_push_subscription_id) FROM stdin;
    public       nolan    false    251   ?�      �          0    60741    settings 
   TABLE DATA               Y   COPY settings (id, var, value, thing_type, created_at, updated_at, thing_id) FROM stdin;
    public       nolan    false    253   i�      �          0    60749    site_uploads 
   TABLE DATA               �   COPY site_uploads (id, var, file_file_name, file_content_type, file_file_size, file_updated_at, meta, created_at, updated_at) FROM stdin;
    public       nolan    false    255   ��      �          0    60758    status_pins 
   TABLE DATA               Q   COPY status_pins (id, account_id, status_id, created_at, updated_at) FROM stdin;
    public       nolan    false    257   ��      �          0    60765    statuses 
   TABLE DATA                 COPY statuses (id, uri, text, created_at, updated_at, in_reply_to_id, reblog_of_id, url, sensitive, visibility, spoiler_text, reply, favourites_count, reblogs_count, language, conversation_id, local, account_id, application_id, in_reply_to_account_id) FROM stdin;
    public       nolan    false    259   �      �          0    60781    statuses_tags 
   TABLE DATA               3   COPY statuses_tags (status_id, tag_id) FROM stdin;
    public       nolan    false    261   ��      �          0    60784    stream_entries 
   TABLE DATA               m   COPY stream_entries (id, activity_id, activity_type, created_at, updated_at, hidden, account_id) FROM stdin;
    public       nolan    false    262   �      �          0    60793    subscriptions 
   TABLE DATA               �   COPY subscriptions (id, callback_url, secret, expires_at, confirmed, created_at, updated_at, last_successful_delivery_at, domain, account_id) FROM stdin;
    public       nolan    false    264   S�      �          0    60803    tags 
   TABLE DATA               9   COPY tags (id, name, created_at, updated_at) FROM stdin;
    public       nolan    false    266   p�      �          0    60812    users 
   TABLE DATA                 COPY users (id, email, created_at, updated_at, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, admin, confirmation_token, confirmed_at, confirmation_sent_at, unconfirmed_email, locale, encrypted_otp_secret, encrypted_otp_secret_iv, encrypted_otp_secret_salt, consumed_timestep, otp_required_for_login, last_emailed_at, otp_backup_codes, filtered_languages, account_id, disabled, moderator, invite_id) FROM stdin;
    public       nolan    false    268   ��      �          0    60828    web_push_subscriptions 
   TABLE DATA               k   COPY web_push_subscriptions (id, endpoint, key_p256dh, key_auth, data, created_at, updated_at) FROM stdin;
    public       nolan    false    270   {�      �          0    60836    web_settings 
   TABLE DATA               J   COPY web_settings (id, data, created_at, updated_at, user_id) FROM stdin;
    public       nolan    false    272   ��      &           0    0    account_domain_blocks_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('account_domain_blocks_id_seq', 1, false);
            public       nolan    false    197            '           0    0    account_moderation_notes_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('account_moderation_notes_id_seq', 1, false);
            public       nolan    false    199            (           0    0    accounts_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('accounts_id_seq', 3, true);
            public       nolan    false    201            )           0    0    admin_action_logs_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('admin_action_logs_id_seq', 1, false);
            public       nolan    false    203            *           0    0    blocks_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('blocks_id_seq', 1, false);
            public       nolan    false    206            +           0    0    conversation_mutes_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('conversation_mutes_id_seq', 1, false);
            public       nolan    false    208            ,           0    0    conversations_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('conversations_id_seq', 51, true);
            public       nolan    false    210            -           0    0    custom_emojis_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('custom_emojis_id_seq', 1, false);
            public       nolan    false    212            .           0    0    domain_blocks_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('domain_blocks_id_seq', 1, false);
            public       nolan    false    214            /           0    0    email_domain_blocks_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('email_domain_blocks_id_seq', 1, false);
            public       nolan    false    216            0           0    0    favourites_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('favourites_id_seq', 7, true);
            public       nolan    false    218            1           0    0    follow_requests_id_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('follow_requests_id_seq', 1, false);
            public       nolan    false    220            2           0    0    follows_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('follows_id_seq', 5, true);
            public       nolan    false    222            3           0    0    imports_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('imports_id_seq', 1, false);
            public       nolan    false    224            4           0    0    invites_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('invites_id_seq', 1, false);
            public       nolan    false    226            5           0    0    list_accounts_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('list_accounts_id_seq', 1, false);
            public       nolan    false    228            6           0    0    lists_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('lists_id_seq', 1, false);
            public       nolan    false    230            7           0    0    media_attachments_id_seq    SEQUENCE SET     ?   SELECT pg_catalog.setval('media_attachments_id_seq', 9, true);
            public       nolan    false    232            8           0    0    mentions_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('mentions_id_seq', 6, true);
            public       nolan    false    234            9           0    0    mutes_id_seq    SEQUENCE SET     4   SELECT pg_catalog.setval('mutes_id_seq', 1, false);
            public       nolan    false    236            :           0    0    notifications_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('notifications_id_seq', 20, true);
            public       nolan    false    238            ;           0    0    oauth_access_grants_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('oauth_access_grants_id_seq', 163, true);
            public       nolan    false    240            <           0    0    oauth_access_tokens_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('oauth_access_tokens_id_seq', 348, true);
            public       nolan    false    242            =           0    0    oauth_applications_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('oauth_applications_id_seq', 204, true);
            public       nolan    false    244            >           0    0    preview_cards_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('preview_cards_id_seq', 1, false);
            public       nolan    false    246            ?           0    0    reports_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('reports_id_seq', 1, false);
            public       nolan    false    249            @           0    0    session_activations_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('session_activations_id_seq', 188, true);
            public       nolan    false    252            A           0    0    settings_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('settings_id_seq', 1, false);
            public       nolan    false    254            B           0    0    site_uploads_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('site_uploads_id_seq', 1, false);
            public       nolan    false    256            C           0    0    status_pins_id_seq    SEQUENCE SET     9   SELECT pg_catalog.setval('status_pins_id_seq', 3, true);
            public       nolan    false    258            D           0    0    statuses_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('statuses_id_seq', 77, true);
            public       nolan    false    260            E           0    0    stream_entries_id_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('stream_entries_id_seq', 77, true);
            public       nolan    false    263            F           0    0    subscriptions_id_seq    SEQUENCE SET     <   SELECT pg_catalog.setval('subscriptions_id_seq', 1, false);
            public       nolan    false    265            G           0    0    tags_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('tags_id_seq', 1, false);
            public       nolan    false    267            H           0    0    users_id_seq    SEQUENCE SET     3   SELECT pg_catalog.setval('users_id_seq', 3, true);
            public       nolan    false    269            I           0    0    web_push_subscriptions_id_seq    SEQUENCE SET     E   SELECT pg_catalog.setval('web_push_subscriptions_id_seq', 1, false);
            public       nolan    false    271            J           0    0    web_settings_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('web_settings_id_seq', 3, true);
            public       nolan    false    273            n
           2606    60884 0   account_domain_blocks account_domain_blocks_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY account_domain_blocks
    ADD CONSTRAINT account_domain_blocks_pkey PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public.account_domain_blocks DROP CONSTRAINT account_domain_blocks_pkey;
       public         nolan    false    196            q
           2606    60886 6   account_moderation_notes account_moderation_notes_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT account_moderation_notes_pkey PRIMARY KEY (id);
 `   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT account_moderation_notes_pkey;
       public         nolan    false    198            u
           2606    60888    accounts accounts_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY accounts
    ADD CONSTRAINT accounts_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.accounts DROP CONSTRAINT accounts_pkey;
       public         nolan    false    200            |
           2606    60890 (   admin_action_logs admin_action_logs_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY admin_action_logs
    ADD CONSTRAINT admin_action_logs_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.admin_action_logs DROP CONSTRAINT admin_action_logs_pkey;
       public         nolan    false    202            �
           2606    60892 .   ar_internal_metadata ar_internal_metadata_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);
 X   ALTER TABLE ONLY public.ar_internal_metadata DROP CONSTRAINT ar_internal_metadata_pkey;
       public         nolan    false    204            �
           2606    60894    blocks blocks_pkey 
   CONSTRAINT     I   ALTER TABLE ONLY blocks
    ADD CONSTRAINT blocks_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.blocks DROP CONSTRAINT blocks_pkey;
       public         nolan    false    205            �
           2606    60896 *   conversation_mutes conversation_mutes_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT conversation_mutes_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT conversation_mutes_pkey;
       public         nolan    false    207            �
           2606    60898     conversations conversations_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.conversations DROP CONSTRAINT conversations_pkey;
       public         nolan    false    209            �
           2606    60900     custom_emojis custom_emojis_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY custom_emojis
    ADD CONSTRAINT custom_emojis_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.custom_emojis DROP CONSTRAINT custom_emojis_pkey;
       public         nolan    false    211            �
           2606    60902     domain_blocks domain_blocks_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY domain_blocks
    ADD CONSTRAINT domain_blocks_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.domain_blocks DROP CONSTRAINT domain_blocks_pkey;
       public         nolan    false    213            �
           2606    60904 ,   email_domain_blocks email_domain_blocks_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY email_domain_blocks
    ADD CONSTRAINT email_domain_blocks_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.email_domain_blocks DROP CONSTRAINT email_domain_blocks_pkey;
       public         nolan    false    215            �
           2606    60906    favourites favourites_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY favourites
    ADD CONSTRAINT favourites_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.favourites DROP CONSTRAINT favourites_pkey;
       public         nolan    false    217            �
           2606    60908 $   follow_requests follow_requests_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT follow_requests_pkey PRIMARY KEY (id);
 N   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT follow_requests_pkey;
       public         nolan    false    219            �
           2606    60910    follows follows_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY follows
    ADD CONSTRAINT follows_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.follows DROP CONSTRAINT follows_pkey;
       public         nolan    false    221            �
           2606    60912    imports imports_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY imports
    ADD CONSTRAINT imports_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.imports DROP CONSTRAINT imports_pkey;
       public         nolan    false    223            �
           2606    60914    invites invites_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY invites
    ADD CONSTRAINT invites_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.invites DROP CONSTRAINT invites_pkey;
       public         nolan    false    225            �
           2606    60916     list_accounts list_accounts_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT list_accounts_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT list_accounts_pkey;
       public         nolan    false    227            �
           2606    60918    lists lists_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY lists
    ADD CONSTRAINT lists_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.lists DROP CONSTRAINT lists_pkey;
       public         nolan    false    229            �
           2606    60920 (   media_attachments media_attachments_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT media_attachments_pkey PRIMARY KEY (id);
 R   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT media_attachments_pkey;
       public         nolan    false    231            �
           2606    60922    mentions mentions_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY mentions
    ADD CONSTRAINT mentions_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.mentions DROP CONSTRAINT mentions_pkey;
       public         nolan    false    233            �
           2606    60924    mutes mutes_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY mutes
    ADD CONSTRAINT mutes_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.mutes DROP CONSTRAINT mutes_pkey;
       public         nolan    false    235            �
           2606    60926     notifications notifications_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.notifications DROP CONSTRAINT notifications_pkey;
       public         nolan    false    237            �
           2606    60928 ,   oauth_access_grants oauth_access_grants_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT oauth_access_grants_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT oauth_access_grants_pkey;
       public         nolan    false    239            �
           2606    60930 ,   oauth_access_tokens oauth_access_tokens_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT oauth_access_tokens_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT oauth_access_tokens_pkey;
       public         nolan    false    241            �
           2606    60932 *   oauth_applications oauth_applications_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT oauth_applications_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.oauth_applications DROP CONSTRAINT oauth_applications_pkey;
       public         nolan    false    243            �
           2606    60934     preview_cards preview_cards_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY preview_cards
    ADD CONSTRAINT preview_cards_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.preview_cards DROP CONSTRAINT preview_cards_pkey;
       public         nolan    false    245            �
           2606    60936    reports reports_pkey 
   CONSTRAINT     K   ALTER TABLE ONLY reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);
 >   ALTER TABLE ONLY public.reports DROP CONSTRAINT reports_pkey;
       public         nolan    false    248            �
           2606    60938 (   schema_migrations schema_migrations_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);
 R   ALTER TABLE ONLY public.schema_migrations DROP CONSTRAINT schema_migrations_pkey;
       public         nolan    false    250            �
           2606    60940 ,   session_activations session_activations_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT session_activations_pkey PRIMARY KEY (id);
 V   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT session_activations_pkey;
       public         nolan    false    251            �
           2606    60942    settings settings_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.settings DROP CONSTRAINT settings_pkey;
       public         nolan    false    253            �
           2606    60944    site_uploads site_uploads_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY site_uploads
    ADD CONSTRAINT site_uploads_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.site_uploads DROP CONSTRAINT site_uploads_pkey;
       public         nolan    false    255            �
           2606    60946    status_pins status_pins_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT status_pins_pkey PRIMARY KEY (id);
 F   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT status_pins_pkey;
       public         nolan    false    257            �
           2606    60948    statuses statuses_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY statuses
    ADD CONSTRAINT statuses_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT statuses_pkey;
       public         nolan    false    259            �
           2606    60950 "   stream_entries stream_entries_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY stream_entries
    ADD CONSTRAINT stream_entries_pkey PRIMARY KEY (id);
 L   ALTER TABLE ONLY public.stream_entries DROP CONSTRAINT stream_entries_pkey;
       public         nolan    false    262            �
           2606    60952     subscriptions subscriptions_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT subscriptions_pkey;
       public         nolan    false    264            �
           2606    60954    tags tags_pkey 
   CONSTRAINT     E   ALTER TABLE ONLY tags
    ADD CONSTRAINT tags_pkey PRIMARY KEY (id);
 8   ALTER TABLE ONLY public.tags DROP CONSTRAINT tags_pkey;
       public         nolan    false    266            �
           2606    60956    users users_pkey 
   CONSTRAINT     G   ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public         nolan    false    268            �
           2606    60958 2   web_push_subscriptions web_push_subscriptions_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY web_push_subscriptions
    ADD CONSTRAINT web_push_subscriptions_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.web_push_subscriptions DROP CONSTRAINT web_push_subscriptions_pkey;
       public         nolan    false    270            �
           2606    60960    web_settings web_settings_pkey 
   CONSTRAINT     U   ALTER TABLE ONLY web_settings
    ADD CONSTRAINT web_settings_pkey PRIMARY KEY (id);
 H   ALTER TABLE ONLY public.web_settings DROP CONSTRAINT web_settings_pkey;
       public         nolan    false    272            �
           1259    60961    account_activity    INDEX     l   CREATE UNIQUE INDEX account_activity ON notifications USING btree (account_id, activity_id, activity_type);
 $   DROP INDEX public.account_activity;
       public         nolan    false    237    237    237            �
           1259    60962    hashtag_search_index    INDEX     ^   CREATE INDEX hashtag_search_index ON tags USING btree (lower((name)::text) text_pattern_ops);
 (   DROP INDEX public.hashtag_search_index;
       public         nolan    false    266    266            o
           1259    60963 4   index_account_domain_blocks_on_account_id_and_domain    INDEX     �   CREATE UNIQUE INDEX index_account_domain_blocks_on_account_id_and_domain ON account_domain_blocks USING btree (account_id, domain);
 H   DROP INDEX public.index_account_domain_blocks_on_account_id_and_domain;
       public         nolan    false    196    196            r
           1259    60964 ,   index_account_moderation_notes_on_account_id    INDEX     p   CREATE INDEX index_account_moderation_notes_on_account_id ON account_moderation_notes USING btree (account_id);
 @   DROP INDEX public.index_account_moderation_notes_on_account_id;
       public         nolan    false    198            s
           1259    60965 3   index_account_moderation_notes_on_target_account_id    INDEX     ~   CREATE INDEX index_account_moderation_notes_on_target_account_id ON account_moderation_notes USING btree (target_account_id);
 G   DROP INDEX public.index_account_moderation_notes_on_target_account_id;
       public         nolan    false    198            v
           1259    60966    index_accounts_on_uri    INDEX     B   CREATE INDEX index_accounts_on_uri ON accounts USING btree (uri);
 )   DROP INDEX public.index_accounts_on_uri;
       public         nolan    false    200            w
           1259    60967    index_accounts_on_url    INDEX     B   CREATE INDEX index_accounts_on_url ON accounts USING btree (url);
 )   DROP INDEX public.index_accounts_on_url;
       public         nolan    false    200            x
           1259    60968 %   index_accounts_on_username_and_domain    INDEX     f   CREATE UNIQUE INDEX index_accounts_on_username_and_domain ON accounts USING btree (username, domain);
 9   DROP INDEX public.index_accounts_on_username_and_domain;
       public         nolan    false    200    200            y
           1259    60969 +   index_accounts_on_username_and_domain_lower    INDEX     �   CREATE INDEX index_accounts_on_username_and_domain_lower ON accounts USING btree (lower((username)::text), lower((domain)::text));
 ?   DROP INDEX public.index_accounts_on_username_and_domain_lower;
       public         nolan    false    200    200    200            }
           1259    60970 %   index_admin_action_logs_on_account_id    INDEX     b   CREATE INDEX index_admin_action_logs_on_account_id ON admin_action_logs USING btree (account_id);
 9   DROP INDEX public.index_admin_action_logs_on_account_id;
       public         nolan    false    202            ~
           1259    60971 4   index_admin_action_logs_on_target_type_and_target_id    INDEX     }   CREATE INDEX index_admin_action_logs_on_target_type_and_target_id ON admin_action_logs USING btree (target_type, target_id);
 H   DROP INDEX public.index_admin_action_logs_on_target_type_and_target_id;
       public         nolan    false    202    202            �
           1259    60972 0   index_blocks_on_account_id_and_target_account_id    INDEX     |   CREATE UNIQUE INDEX index_blocks_on_account_id_and_target_account_id ON blocks USING btree (account_id, target_account_id);
 D   DROP INDEX public.index_blocks_on_account_id_and_target_account_id;
       public         nolan    false    205    205            �
           1259    60973 :   index_conversation_mutes_on_account_id_and_conversation_id    INDEX     �   CREATE UNIQUE INDEX index_conversation_mutes_on_account_id_and_conversation_id ON conversation_mutes USING btree (account_id, conversation_id);
 N   DROP INDEX public.index_conversation_mutes_on_account_id_and_conversation_id;
       public         nolan    false    207    207            �
           1259    60974    index_conversations_on_uri    INDEX     S   CREATE UNIQUE INDEX index_conversations_on_uri ON conversations USING btree (uri);
 .   DROP INDEX public.index_conversations_on_uri;
       public         nolan    false    209            �
           1259    60975 +   index_custom_emojis_on_shortcode_and_domain    INDEX     r   CREATE UNIQUE INDEX index_custom_emojis_on_shortcode_and_domain ON custom_emojis USING btree (shortcode, domain);
 ?   DROP INDEX public.index_custom_emojis_on_shortcode_and_domain;
       public         nolan    false    211    211            �
           1259    60976    index_domain_blocks_on_domain    INDEX     Y   CREATE UNIQUE INDEX index_domain_blocks_on_domain ON domain_blocks USING btree (domain);
 1   DROP INDEX public.index_domain_blocks_on_domain;
       public         nolan    false    213            �
           1259    60977 #   index_email_domain_blocks_on_domain    INDEX     e   CREATE UNIQUE INDEX index_email_domain_blocks_on_domain ON email_domain_blocks USING btree (domain);
 7   DROP INDEX public.index_email_domain_blocks_on_domain;
       public         nolan    false    215            �
           1259    60978 %   index_favourites_on_account_id_and_id    INDEX     _   CREATE INDEX index_favourites_on_account_id_and_id ON favourites USING btree (account_id, id);
 9   DROP INDEX public.index_favourites_on_account_id_and_id;
       public         nolan    false    217    217            �
           1259    60979 ,   index_favourites_on_account_id_and_status_id    INDEX     t   CREATE UNIQUE INDEX index_favourites_on_account_id_and_status_id ON favourites USING btree (account_id, status_id);
 @   DROP INDEX public.index_favourites_on_account_id_and_status_id;
       public         nolan    false    217    217            �
           1259    60980    index_favourites_on_status_id    INDEX     R   CREATE INDEX index_favourites_on_status_id ON favourites USING btree (status_id);
 1   DROP INDEX public.index_favourites_on_status_id;
       public         nolan    false    217            �
           1259    60981 9   index_follow_requests_on_account_id_and_target_account_id    INDEX     �   CREATE UNIQUE INDEX index_follow_requests_on_account_id_and_target_account_id ON follow_requests USING btree (account_id, target_account_id);
 M   DROP INDEX public.index_follow_requests_on_account_id_and_target_account_id;
       public         nolan    false    219    219            �
           1259    60982 1   index_follows_on_account_id_and_target_account_id    INDEX     ~   CREATE UNIQUE INDEX index_follows_on_account_id_and_target_account_id ON follows USING btree (account_id, target_account_id);
 E   DROP INDEX public.index_follows_on_account_id_and_target_account_id;
       public         nolan    false    221    221            �
           1259    60983    index_invites_on_code    INDEX     I   CREATE UNIQUE INDEX index_invites_on_code ON invites USING btree (code);
 )   DROP INDEX public.index_invites_on_code;
       public         nolan    false    225            �
           1259    60984    index_invites_on_user_id    INDEX     H   CREATE INDEX index_invites_on_user_id ON invites USING btree (user_id);
 ,   DROP INDEX public.index_invites_on_user_id;
       public         nolan    false    225            �
           1259    60985 -   index_list_accounts_on_account_id_and_list_id    INDEX     v   CREATE UNIQUE INDEX index_list_accounts_on_account_id_and_list_id ON list_accounts USING btree (account_id, list_id);
 A   DROP INDEX public.index_list_accounts_on_account_id_and_list_id;
       public         nolan    false    227    227            �
           1259    60986     index_list_accounts_on_follow_id    INDEX     X   CREATE INDEX index_list_accounts_on_follow_id ON list_accounts USING btree (follow_id);
 4   DROP INDEX public.index_list_accounts_on_follow_id;
       public         nolan    false    227            �
           1259    60987 -   index_list_accounts_on_list_id_and_account_id    INDEX     o   CREATE INDEX index_list_accounts_on_list_id_and_account_id ON list_accounts USING btree (list_id, account_id);
 A   DROP INDEX public.index_list_accounts_on_list_id_and_account_id;
       public         nolan    false    227    227            �
           1259    60988    index_lists_on_account_id    INDEX     J   CREATE INDEX index_lists_on_account_id ON lists USING btree (account_id);
 -   DROP INDEX public.index_lists_on_account_id;
       public         nolan    false    229            �
           1259    60989 %   index_media_attachments_on_account_id    INDEX     b   CREATE INDEX index_media_attachments_on_account_id ON media_attachments USING btree (account_id);
 9   DROP INDEX public.index_media_attachments_on_account_id;
       public         nolan    false    231            �
           1259    60990 $   index_media_attachments_on_shortcode    INDEX     g   CREATE UNIQUE INDEX index_media_attachments_on_shortcode ON media_attachments USING btree (shortcode);
 8   DROP INDEX public.index_media_attachments_on_shortcode;
       public         nolan    false    231            �
           1259    60991 $   index_media_attachments_on_status_id    INDEX     `   CREATE INDEX index_media_attachments_on_status_id ON media_attachments USING btree (status_id);
 8   DROP INDEX public.index_media_attachments_on_status_id;
       public         nolan    false    231            �
           1259    60992 *   index_mentions_on_account_id_and_status_id    INDEX     p   CREATE UNIQUE INDEX index_mentions_on_account_id_and_status_id ON mentions USING btree (account_id, status_id);
 >   DROP INDEX public.index_mentions_on_account_id_and_status_id;
       public         nolan    false    233    233            �
           1259    60993    index_mentions_on_status_id    INDEX     N   CREATE INDEX index_mentions_on_status_id ON mentions USING btree (status_id);
 /   DROP INDEX public.index_mentions_on_status_id;
       public         nolan    false    233            �
           1259    60994 /   index_mutes_on_account_id_and_target_account_id    INDEX     z   CREATE UNIQUE INDEX index_mutes_on_account_id_and_target_account_id ON mutes USING btree (account_id, target_account_id);
 C   DROP INDEX public.index_mutes_on_account_id_and_target_account_id;
       public         nolan    false    235    235            �
           1259    60995 (   index_notifications_on_account_id_and_id    INDEX     j   CREATE INDEX index_notifications_on_account_id_and_id ON notifications USING btree (account_id, id DESC);
 <   DROP INDEX public.index_notifications_on_account_id_and_id;
       public         nolan    false    237    237            �
           1259    60996 4   index_notifications_on_activity_id_and_activity_type    INDEX     }   CREATE INDEX index_notifications_on_activity_id_and_activity_type ON notifications USING btree (activity_id, activity_type);
 H   DROP INDEX public.index_notifications_on_activity_id_and_activity_type;
       public         nolan    false    237    237            �
           1259    60997 "   index_oauth_access_grants_on_token    INDEX     c   CREATE UNIQUE INDEX index_oauth_access_grants_on_token ON oauth_access_grants USING btree (token);
 6   DROP INDEX public.index_oauth_access_grants_on_token;
       public         nolan    false    239            �
           1259    60998 *   index_oauth_access_tokens_on_refresh_token    INDEX     s   CREATE UNIQUE INDEX index_oauth_access_tokens_on_refresh_token ON oauth_access_tokens USING btree (refresh_token);
 >   DROP INDEX public.index_oauth_access_tokens_on_refresh_token;
       public         nolan    false    241            �
           1259    60999 .   index_oauth_access_tokens_on_resource_owner_id    INDEX     t   CREATE INDEX index_oauth_access_tokens_on_resource_owner_id ON oauth_access_tokens USING btree (resource_owner_id);
 B   DROP INDEX public.index_oauth_access_tokens_on_resource_owner_id;
       public         nolan    false    241            �
           1259    61000 "   index_oauth_access_tokens_on_token    INDEX     c   CREATE UNIQUE INDEX index_oauth_access_tokens_on_token ON oauth_access_tokens USING btree (token);
 6   DROP INDEX public.index_oauth_access_tokens_on_token;
       public         nolan    false    241            �
           1259    61001 3   index_oauth_applications_on_owner_id_and_owner_type    INDEX     {   CREATE INDEX index_oauth_applications_on_owner_id_and_owner_type ON oauth_applications USING btree (owner_id, owner_type);
 G   DROP INDEX public.index_oauth_applications_on_owner_id_and_owner_type;
       public         nolan    false    243    243            �
           1259    61002    index_oauth_applications_on_uid    INDEX     ]   CREATE UNIQUE INDEX index_oauth_applications_on_uid ON oauth_applications USING btree (uid);
 3   DROP INDEX public.index_oauth_applications_on_uid;
       public         nolan    false    243            �
           1259    61003    index_preview_cards_on_url    INDEX     S   CREATE UNIQUE INDEX index_preview_cards_on_url ON preview_cards USING btree (url);
 .   DROP INDEX public.index_preview_cards_on_url;
       public         nolan    false    245            �
           1259    61004 =   index_preview_cards_statuses_on_status_id_and_preview_card_id    INDEX     �   CREATE INDEX index_preview_cards_statuses_on_status_id_and_preview_card_id ON preview_cards_statuses USING btree (status_id, preview_card_id);
 Q   DROP INDEX public.index_preview_cards_statuses_on_status_id_and_preview_card_id;
       public         nolan    false    247    247            �
           1259    61005    index_reports_on_account_id    INDEX     N   CREATE INDEX index_reports_on_account_id ON reports USING btree (account_id);
 /   DROP INDEX public.index_reports_on_account_id;
       public         nolan    false    248            �
           1259    61006 "   index_reports_on_target_account_id    INDEX     \   CREATE INDEX index_reports_on_target_account_id ON reports USING btree (target_account_id);
 6   DROP INDEX public.index_reports_on_target_account_id;
       public         nolan    false    248            �
           1259    61007 '   index_session_activations_on_session_id    INDEX     m   CREATE UNIQUE INDEX index_session_activations_on_session_id ON session_activations USING btree (session_id);
 ;   DROP INDEX public.index_session_activations_on_session_id;
       public         nolan    false    251            �
           1259    61008 $   index_session_activations_on_user_id    INDEX     `   CREATE INDEX index_session_activations_on_user_id ON session_activations USING btree (user_id);
 8   DROP INDEX public.index_session_activations_on_user_id;
       public         nolan    false    251            �
           1259    61009 1   index_settings_on_thing_type_and_thing_id_and_var    INDEX     {   CREATE UNIQUE INDEX index_settings_on_thing_type_and_thing_id_and_var ON settings USING btree (thing_type, thing_id, var);
 E   DROP INDEX public.index_settings_on_thing_type_and_thing_id_and_var;
       public         nolan    false    253    253    253            �
           1259    61010    index_site_uploads_on_var    INDEX     Q   CREATE UNIQUE INDEX index_site_uploads_on_var ON site_uploads USING btree (var);
 -   DROP INDEX public.index_site_uploads_on_var;
       public         nolan    false    255            �
           1259    61011 -   index_status_pins_on_account_id_and_status_id    INDEX     v   CREATE UNIQUE INDEX index_status_pins_on_account_id_and_status_id ON status_pins USING btree (account_id, status_id);
 A   DROP INDEX public.index_status_pins_on_account_id_and_status_id;
       public         nolan    false    257    257            �
           1259    61012    index_statuses_20180106    INDEX     l   CREATE INDEX index_statuses_20180106 ON statuses USING btree (account_id, id DESC, visibility, updated_at);
 +   DROP INDEX public.index_statuses_20180106;
       public         nolan    false    259    259    259    259            �
           1259    61013 !   index_statuses_on_conversation_id    INDEX     Z   CREATE INDEX index_statuses_on_conversation_id ON statuses USING btree (conversation_id);
 5   DROP INDEX public.index_statuses_on_conversation_id;
       public         nolan    false    259            �
           1259    61014     index_statuses_on_in_reply_to_id    INDEX     X   CREATE INDEX index_statuses_on_in_reply_to_id ON statuses USING btree (in_reply_to_id);
 4   DROP INDEX public.index_statuses_on_in_reply_to_id;
       public         nolan    false    259            �
           1259    61015 -   index_statuses_on_reblog_of_id_and_account_id    INDEX     o   CREATE INDEX index_statuses_on_reblog_of_id_and_account_id ON statuses USING btree (reblog_of_id, account_id);
 A   DROP INDEX public.index_statuses_on_reblog_of_id_and_account_id;
       public         nolan    false    259    259            �
           1259    61016    index_statuses_on_uri    INDEX     I   CREATE UNIQUE INDEX index_statuses_on_uri ON statuses USING btree (uri);
 )   DROP INDEX public.index_statuses_on_uri;
       public         nolan    false    259            �
           1259    61017     index_statuses_tags_on_status_id    INDEX     X   CREATE INDEX index_statuses_tags_on_status_id ON statuses_tags USING btree (status_id);
 4   DROP INDEX public.index_statuses_tags_on_status_id;
       public         nolan    false    261            �
           1259    61018 +   index_statuses_tags_on_tag_id_and_status_id    INDEX     r   CREATE UNIQUE INDEX index_statuses_tags_on_tag_id_and_status_id ON statuses_tags USING btree (tag_id, status_id);
 ?   DROP INDEX public.index_statuses_tags_on_tag_id_and_status_id;
       public         nolan    false    261    261            �
           1259    61019 ;   index_stream_entries_on_account_id_and_activity_type_and_id    INDEX     �   CREATE INDEX index_stream_entries_on_account_id_and_activity_type_and_id ON stream_entries USING btree (account_id, activity_type, id);
 O   DROP INDEX public.index_stream_entries_on_account_id_and_activity_type_and_id;
       public         nolan    false    262    262    262            �
           1259    61020 5   index_stream_entries_on_activity_id_and_activity_type    INDEX        CREATE INDEX index_stream_entries_on_activity_id_and_activity_type ON stream_entries USING btree (activity_id, activity_type);
 I   DROP INDEX public.index_stream_entries_on_activity_id_and_activity_type;
       public         nolan    false    262    262            �
           1259    61021 2   index_subscriptions_on_account_id_and_callback_url    INDEX     �   CREATE UNIQUE INDEX index_subscriptions_on_account_id_and_callback_url ON subscriptions USING btree (account_id, callback_url);
 F   DROP INDEX public.index_subscriptions_on_account_id_and_callback_url;
       public         nolan    false    264    264            �
           1259    61022    index_tags_on_name    INDEX     C   CREATE UNIQUE INDEX index_tags_on_name ON tags USING btree (name);
 &   DROP INDEX public.index_tags_on_name;
       public         nolan    false    266            �
           1259    61023    index_users_on_account_id    INDEX     J   CREATE INDEX index_users_on_account_id ON users USING btree (account_id);
 -   DROP INDEX public.index_users_on_account_id;
       public         nolan    false    268            �
           1259    61024 !   index_users_on_confirmation_token    INDEX     a   CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);
 5   DROP INDEX public.index_users_on_confirmation_token;
       public         nolan    false    268            �
           1259    61025    index_users_on_email    INDEX     G   CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);
 (   DROP INDEX public.index_users_on_email;
       public         nolan    false    268            �
           1259    61026 !   index_users_on_filtered_languages    INDEX     X   CREATE INDEX index_users_on_filtered_languages ON users USING gin (filtered_languages);
 5   DROP INDEX public.index_users_on_filtered_languages;
       public         nolan    false    268            �
           1259    61027 #   index_users_on_reset_password_token    INDEX     e   CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);
 7   DROP INDEX public.index_users_on_reset_password_token;
       public         nolan    false    268            �
           1259    61028    index_web_settings_on_user_id    INDEX     Y   CREATE UNIQUE INDEX index_web_settings_on_user_id ON web_settings USING btree (user_id);
 1   DROP INDEX public.index_web_settings_on_user_id;
       public         nolan    false    272            z
           1259    61029    search_index    INDEX     C  CREATE INDEX search_index ON accounts USING gin ((((setweight(to_tsvector('simple'::regconfig, (display_name)::text), 'A'::"char") || setweight(to_tsvector('simple'::regconfig, (username)::text), 'B'::"char")) || setweight(to_tsvector('simple'::regconfig, (COALESCE(domain, ''::character varying))::text), 'C'::"char"))));
     DROP INDEX public.search_index;
       public         nolan    false    200    200    200    200            3           2606    61030    web_settings fk_11910667b2    FK CONSTRAINT     }   ALTER TABLE ONLY web_settings
    ADD CONSTRAINT fk_11910667b2 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 D   ALTER TABLE ONLY public.web_settings DROP CONSTRAINT fk_11910667b2;
       public       nolan    false    2810    272    268                        2606    61035 #   account_domain_blocks fk_206c6029bd    FK CONSTRAINT     �   ALTER TABLE ONLY account_domain_blocks
    ADD CONSTRAINT fk_206c6029bd FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 M   ALTER TABLE ONLY public.account_domain_blocks DROP CONSTRAINT fk_206c6029bd;
       public       nolan    false    2677    200    196                       2606    61040     conversation_mutes fk_225b4212bb    FK CONSTRAINT     �   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT fk_225b4212bb FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT fk_225b4212bb;
       public       nolan    false    207    200    2677            -           2606    61045    statuses_tags fk_3081861e21    FK CONSTRAINT     |   ALTER TABLE ONLY statuses_tags
    ADD CONSTRAINT fk_3081861e21 FOREIGN KEY (tag_id) REFERENCES tags(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.statuses_tags DROP CONSTRAINT fk_3081861e21;
       public       nolan    false    261    266    2803                       2606    61050    follows fk_32ed1b5560    FK CONSTRAINT     ~   ALTER TABLE ONLY follows
    ADD CONSTRAINT fk_32ed1b5560 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.follows DROP CONSTRAINT fk_32ed1b5560;
       public       nolan    false    221    200    2677                       2606    61055 !   oauth_access_grants fk_34d54b0a33    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT fk_34d54b0a33 FOREIGN KEY (application_id) REFERENCES oauth_applications(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT fk_34d54b0a33;
       public       nolan    false    239    243    2760                       2606    61060    blocks fk_4269e03e65    FK CONSTRAINT     }   ALTER TABLE ONLY blocks
    ADD CONSTRAINT fk_4269e03e65 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.blocks DROP CONSTRAINT fk_4269e03e65;
       public       nolan    false    200    205    2677            "           2606    61065    reports fk_4b81f7522c    FK CONSTRAINT     ~   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_4b81f7522c FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_4b81f7522c;
       public       nolan    false    248    2677    200            1           2606    61070    users fk_50500f500d    FK CONSTRAINT     |   ALTER TABLE ONLY users
    ADD CONSTRAINT fk_50500f500d FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_50500f500d;
       public       nolan    false    268    2677    200            /           2606    61075    stream_entries fk_5659b17554    FK CONSTRAINT     �   ALTER TABLE ONLY stream_entries
    ADD CONSTRAINT fk_5659b17554 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.stream_entries DROP CONSTRAINT fk_5659b17554;
       public       nolan    false    2677    200    262            	           2606    61080    favourites fk_5eb6c2b873    FK CONSTRAINT     �   ALTER TABLE ONLY favourites
    ADD CONSTRAINT fk_5eb6c2b873 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.favourites DROP CONSTRAINT fk_5eb6c2b873;
       public       nolan    false    2677    217    200                       2606    61085 !   oauth_access_grants fk_63b044929b    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_grants
    ADD CONSTRAINT fk_63b044929b FOREIGN KEY (resource_owner_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_grants DROP CONSTRAINT fk_63b044929b;
       public       nolan    false    268    239    2810                       2606    61090    imports fk_6db1b6e408    FK CONSTRAINT     ~   ALTER TABLE ONLY imports
    ADD CONSTRAINT fk_6db1b6e408 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.imports DROP CONSTRAINT fk_6db1b6e408;
       public       nolan    false    223    200    2677                       2606    61095    follows fk_745ca29eac    FK CONSTRAINT     �   ALTER TABLE ONLY follows
    ADD CONSTRAINT fk_745ca29eac FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.follows DROP CONSTRAINT fk_745ca29eac;
       public       nolan    false    200    221    2677                       2606    61100    follow_requests fk_76d644b0e7    FK CONSTRAINT     �   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT fk_76d644b0e7 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT fk_76d644b0e7;
       public       nolan    false    219    200    2677                       2606    61105    follow_requests fk_9291ec025d    FK CONSTRAINT     �   ALTER TABLE ONLY follow_requests
    ADD CONSTRAINT fk_9291ec025d FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 G   ALTER TABLE ONLY public.follow_requests DROP CONSTRAINT fk_9291ec025d;
       public       nolan    false    219    200    2677                       2606    61110    blocks fk_9571bfabc1    FK CONSTRAINT     �   ALTER TABLE ONLY blocks
    ADD CONSTRAINT fk_9571bfabc1 FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 >   ALTER TABLE ONLY public.blocks DROP CONSTRAINT fk_9571bfabc1;
       public       nolan    false    200    205    2677            %           2606    61115 !   session_activations fk_957e5bda89    FK CONSTRAINT     �   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT fk_957e5bda89 FOREIGN KEY (access_token_id) REFERENCES oauth_access_tokens(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT fk_957e5bda89;
       public       nolan    false    251    241    2756                       2606    61120    media_attachments fk_96dd81e81b    FK CONSTRAINT     �   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT fk_96dd81e81b FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 I   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT fk_96dd81e81b;
       public       nolan    false    231    2677    200                       2606    61125    mentions fk_970d43f9d1    FK CONSTRAINT        ALTER TABLE ONLY mentions
    ADD CONSTRAINT fk_970d43f9d1 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.mentions DROP CONSTRAINT fk_970d43f9d1;
       public       nolan    false    200    233    2677            0           2606    61130    subscriptions fk_9847d1cbb5    FK CONSTRAINT     �   ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT fk_9847d1cbb5 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.subscriptions DROP CONSTRAINT fk_9847d1cbb5;
       public       nolan    false    2677    200    264            )           2606    61135    statuses fk_9bda1543f7    FK CONSTRAINT        ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_9bda1543f7 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_9bda1543f7;
       public       nolan    false    259    2677    200            !           2606    61140     oauth_applications fk_b0988c7c0a    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_applications
    ADD CONSTRAINT fk_b0988c7c0a FOREIGN KEY (owner_id) REFERENCES users(id) ON DELETE CASCADE;
 J   ALTER TABLE ONLY public.oauth_applications DROP CONSTRAINT fk_b0988c7c0a;
       public       nolan    false    268    243    2810            
           2606    61145    favourites fk_b0e856845e    FK CONSTRAINT     �   ALTER TABLE ONLY favourites
    ADD CONSTRAINT fk_b0e856845e FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.favourites DROP CONSTRAINT fk_b0e856845e;
       public       nolan    false    2790    217    259                       2606    61150    mutes fk_b8d8daf315    FK CONSTRAINT     |   ALTER TABLE ONLY mutes
    ADD CONSTRAINT fk_b8d8daf315 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.mutes DROP CONSTRAINT fk_b8d8daf315;
       public       nolan    false    200    235    2677            #           2606    61155    reports fk_bca45b75fd    FK CONSTRAINT     �   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_bca45b75fd FOREIGN KEY (action_taken_by_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_bca45b75fd;
       public       nolan    false    200    248    2677                       2606    61160    notifications fk_c141c8ee55    FK CONSTRAINT     �   ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_c141c8ee55 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.notifications DROP CONSTRAINT fk_c141c8ee55;
       public       nolan    false    2677    200    237            *           2606    61165    statuses fk_c7fa917661    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_c7fa917661 FOREIGN KEY (in_reply_to_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 @   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_c7fa917661;
       public       nolan    false    200    259    2677            '           2606    61170    status_pins fk_d4cb435b62    FK CONSTRAINT     �   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT fk_d4cb435b62 FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT fk_d4cb435b62;
       public       nolan    false    257    2677    200            &           2606    61175 !   session_activations fk_e5fda67334    FK CONSTRAINT     �   ALTER TABLE ONLY session_activations
    ADD CONSTRAINT fk_e5fda67334 FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.session_activations DROP CONSTRAINT fk_e5fda67334;
       public       nolan    false    268    2810    251                       2606    61180 !   oauth_access_tokens fk_e84df68546    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT fk_e84df68546 FOREIGN KEY (resource_owner_id) REFERENCES users(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT fk_e84df68546;
       public       nolan    false    268    241    2810            $           2606    61185    reports fk_eb37af34f0    FK CONSTRAINT     �   ALTER TABLE ONLY reports
    ADD CONSTRAINT fk_eb37af34f0 FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 ?   ALTER TABLE ONLY public.reports DROP CONSTRAINT fk_eb37af34f0;
       public       nolan    false    248    2677    200                       2606    61190    mutes fk_eecff219ea    FK CONSTRAINT     �   ALTER TABLE ONLY mutes
    ADD CONSTRAINT fk_eecff219ea FOREIGN KEY (target_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 =   ALTER TABLE ONLY public.mutes DROP CONSTRAINT fk_eecff219ea;
       public       nolan    false    200    235    2677                        2606    61195 !   oauth_access_tokens fk_f5fc4c1ee3    FK CONSTRAINT     �   ALTER TABLE ONLY oauth_access_tokens
    ADD CONSTRAINT fk_f5fc4c1ee3 FOREIGN KEY (application_id) REFERENCES oauth_applications(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.oauth_access_tokens DROP CONSTRAINT fk_f5fc4c1ee3;
       public       nolan    false    241    2760    243                       2606    61200    notifications fk_fbd6b0bf9e    FK CONSTRAINT     �   ALTER TABLE ONLY notifications
    ADD CONSTRAINT fk_fbd6b0bf9e FOREIGN KEY (from_account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.notifications DROP CONSTRAINT fk_fbd6b0bf9e;
       public       nolan    false    200    2677    237                       2606    61205    accounts fk_rails_2320833084    FK CONSTRAINT     �   ALTER TABLE ONLY accounts
    ADD CONSTRAINT fk_rails_2320833084 FOREIGN KEY (moved_to_account_id) REFERENCES accounts(id) ON DELETE SET NULL;
 F   ALTER TABLE ONLY public.accounts DROP CONSTRAINT fk_rails_2320833084;
       public       nolan    false    2677    200    200            +           2606    61210    statuses fk_rails_256483a9ab    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_rails_256483a9ab FOREIGN KEY (reblog_of_id) REFERENCES statuses(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_rails_256483a9ab;
       public       nolan    false    259    259    2790                       2606    61215    lists fk_rails_3853b78dac    FK CONSTRAINT     �   ALTER TABLE ONLY lists
    ADD CONSTRAINT fk_rails_3853b78dac FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.lists DROP CONSTRAINT fk_rails_3853b78dac;
       public       nolan    false    200    2677    229                       2606    61220 %   media_attachments fk_rails_3ec0cfdd70    FK CONSTRAINT     �   ALTER TABLE ONLY media_attachments
    ADD CONSTRAINT fk_rails_3ec0cfdd70 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE SET NULL;
 O   ALTER TABLE ONLY public.media_attachments DROP CONSTRAINT fk_rails_3ec0cfdd70;
       public       nolan    false    259    2790    231                       2606    61225 ,   account_moderation_notes fk_rails_3f8b75089b    FK CONSTRAINT     �   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT fk_rails_3f8b75089b FOREIGN KEY (account_id) REFERENCES accounts(id);
 V   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT fk_rails_3f8b75089b;
       public       nolan    false    200    2677    198                       2606    61230 !   list_accounts fk_rails_40f9cc29f1    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_40f9cc29f1 FOREIGN KEY (follow_id) REFERENCES follows(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_40f9cc29f1;
       public       nolan    false    227    221    2716                       2606    61235    mentions fk_rails_59edbe2887    FK CONSTRAINT     �   ALTER TABLE ONLY mentions
    ADD CONSTRAINT fk_rails_59edbe2887 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 F   ALTER TABLE ONLY public.mentions DROP CONSTRAINT fk_rails_59edbe2887;
       public       nolan    false    2790    259    233                       2606    61240 &   conversation_mutes fk_rails_5ab139311f    FK CONSTRAINT     �   ALTER TABLE ONLY conversation_mutes
    ADD CONSTRAINT fk_rails_5ab139311f FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON DELETE CASCADE;
 P   ALTER TABLE ONLY public.conversation_mutes DROP CONSTRAINT fk_rails_5ab139311f;
       public       nolan    false    2696    209    207            (           2606    61245    status_pins fk_rails_65c05552f1    FK CONSTRAINT     �   ALTER TABLE ONLY status_pins
    ADD CONSTRAINT fk_rails_65c05552f1 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 I   ALTER TABLE ONLY public.status_pins DROP CONSTRAINT fk_rails_65c05552f1;
       public       nolan    false    257    259    2790                       2606    61250 !   list_accounts fk_rails_85fee9d6ab    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_85fee9d6ab FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_85fee9d6ab;
       public       nolan    false    2677    227    200            2           2606    61255    users fk_rails_8fb2a43e88    FK CONSTRAINT     �   ALTER TABLE ONLY users
    ADD CONSTRAINT fk_rails_8fb2a43e88 FOREIGN KEY (invite_id) REFERENCES invites(id) ON DELETE SET NULL;
 C   ALTER TABLE ONLY public.users DROP CONSTRAINT fk_rails_8fb2a43e88;
       public       nolan    false    268    2723    225            ,           2606    61260    statuses fk_rails_94a6f70399    FK CONSTRAINT     �   ALTER TABLE ONLY statuses
    ADD CONSTRAINT fk_rails_94a6f70399 FOREIGN KEY (in_reply_to_id) REFERENCES statuses(id) ON DELETE SET NULL;
 F   ALTER TABLE ONLY public.statuses DROP CONSTRAINT fk_rails_94a6f70399;
       public       nolan    false    259    259    2790                       2606    61265 %   admin_action_logs fk_rails_a7667297fa    FK CONSTRAINT     �   ALTER TABLE ONLY admin_action_logs
    ADD CONSTRAINT fk_rails_a7667297fa FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE;
 O   ALTER TABLE ONLY public.admin_action_logs DROP CONSTRAINT fk_rails_a7667297fa;
       public       nolan    false    2677    200    202                       2606    61270 ,   account_moderation_notes fk_rails_dd62ed5ac3    FK CONSTRAINT     �   ALTER TABLE ONLY account_moderation_notes
    ADD CONSTRAINT fk_rails_dd62ed5ac3 FOREIGN KEY (target_account_id) REFERENCES accounts(id);
 V   ALTER TABLE ONLY public.account_moderation_notes DROP CONSTRAINT fk_rails_dd62ed5ac3;
       public       nolan    false    200    198    2677            .           2606    61275 !   statuses_tags fk_rails_df0fe11427    FK CONSTRAINT     �   ALTER TABLE ONLY statuses_tags
    ADD CONSTRAINT fk_rails_df0fe11427 FOREIGN KEY (status_id) REFERENCES statuses(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.statuses_tags DROP CONSTRAINT fk_rails_df0fe11427;
       public       nolan    false    2790    259    261                       2606    61280 !   list_accounts fk_rails_e54e356c88    FK CONSTRAINT     �   ALTER TABLE ONLY list_accounts
    ADD CONSTRAINT fk_rails_e54e356c88 FOREIGN KEY (list_id) REFERENCES lists(id) ON DELETE CASCADE;
 K   ALTER TABLE ONLY public.list_accounts DROP CONSTRAINT fk_rails_e54e356c88;
       public       nolan    false    2731    229    227                       2606    61285    invites fk_rails_ff69dbb2ac    FK CONSTRAINT     ~   ALTER TABLE ONLY invites
    ADD CONSTRAINT fk_rails_ff69dbb2ac FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
 E   ALTER TABLE ONLY public.invites DROP CONSTRAINT fk_rails_ff69dbb2ac;
       public       nolan    false    225    2810    268            �      x������ � �      �      x������ � �      �      x���GϫZ�@ǧŝ�n��+�9�`�	��������z��:|�GޒU�]Uk�F~d}��/�Ǐ��|^���,���a�O�������W��2��2C�w�6y��'�=kD^4�܉�@x��
H���"a"^	J������'~GPk��P;+"�>��Ϥ���q�v*���" `�>�Vn�q� 7�"��N�&��c"�����%#ܽ�Y�f6E= :�CF��U��hZ�*�?f 	ĭ�b�@�ȍ ��g?n���~�٨zOp�,��,(�/ ���s8�۞@uy�쵋<ӧn�	4�Po$d���*�/��PF!$�r�O���d�ѨM&�$j:��I��2Vp�x ��U�[�p�V$�P���0��m��_o�,� �F1����+���b�F�X��Y��|��d��`�F02dP-��^�⚝�	,ѧ{N�:�z8x�W]�27���5@�ĻܢD���`'�c4��6}p�QÑF�j���ChwW�ah5 M�ڥ!r��Ff�<G@>���9���m8_�2�5n��X��pg �̀ڳ[�q�D`��=��Y��q���[�7+�E2�0ɿmk��00_@�z���h8z��'�X���ܴ��;�,��ę�l�^�L�����^��y7�|u�v�>Ƴy���N��Fd��+�f�ڱ��"��M�a<����&*	�8�W7�s�)�4+��q�0��i9�l�9�G�\,O�Ns��8�SSy��Iı,b�3L�<��hsg��K�M����F����5D3���۬�ls>D��W̷t�^].����$2I�+����IR�n�G*��yľx)G��,oE����ܞ�w�i��A�G�Y�NE���p\��X���H�����OΡ��L���]��]A��I�E��
�t���'�)��T.�hІ�����W�t�{<�W"f�O�#�խ�в�:��>�=�w�L�-��T�7�Äyj#�}ԕ�f4������Bw.�����mP �u�[o�h���}�E8�&Z�q��_cfx7�$✝.�\�N�(ٳ�
a5�`�sgrנ��!7��Y}O�i]��މ5;�[�����j�Ć��5��8E���ߖ|�G{���C��H�\)����|��y.V�b�+��S�Dy��dE0Q���}֋盫�]��i�Xȁm����=J�j
����W�I�@�"��һ2F���7�e�s*��M� �ee�RdQ{_ظ=�{����+�yuܓ��$K���(�V,�[��^�Tz��ӛ���m�!2� ����������p�j�u:�O�EXU��3���w2�ee%�)5�V;���������W�6����S�Qe����+Zg�z,�R�>s�J�i�"I�\g��L������w�����w�����w�����w�����w�����_8�9�׃@0�W�+L�S�����7��0�j�z.g������������\t�������u����?��4���[�=:��,)fde؈�Ñ����IZ-��q0�n]��f���
�a$��Xg��""D-Y�j��a�g d�n.�)X{u��>���o!UAr	p
��������{����gǜ��'����0H��������x)+�!��V��(g�O�H�s!*�ѧf7ȹ�{�ܟN����W��.��*z{�Ni�m���s�Oh�L�8�a���85����HL��x�6�Q�E�=FP�g�Q@1�w���eJEI=����'��#�G1��R`�>?3�-}H��	Z�����]]�E�e1�j}�º�1�ybi�`�{'�<�+�ȿ��럲�����VN�E)�H"	T�i}�U'�J�Jl/��-qߊ�WGf�}�:ֻ�}��$M�^M���#7d��(P���`�:���9	��nx���^102p��8�N��<���U)Q���Z	j�|�?W0x��d�[�X���J^]��{	�͢�<r�{�j�?N�����-��nc"�Jq��&H�j��s���Fa���r�i���q��23�������צ�B�-K)�T�W��ޮ
��}�P�6�IƋ_��c;r$���4~K��� �r�a�@�W�a�rR`�#�.℔�޹�!�X絲�m�?���%�a�"Ϧ�IiE�q���L���C����{�xP�]��{��o�����1�s���p!-�M��S��A#�e-��*�1wU�jV̓t�`Z�K��A�aI^��7�3���t8�dѫ�{dϝi�ā��[dP� c������m]ǆ�ƿ���Cz�pq��U���|�f���N|�U��fJ�}Բ�8ԏ�h���r�8F�Ol{3��M�~��V��:�8�{��`$��豧F���ɤ=ڑI�O�O�	o�D�i����""� ��0� �m�N��F���}���G�@}��h�Ǔi�b��c��K4���w���W�8�b��c�i��uA
f�3�˘,V��&�m��o?�BW��&Ϭ�(��5Qt`�g�P ct�����jm3���9��W�ӷ���y+�|f9��p�����x��E}��m�V+�c�؛��''aX눫�3��E���[�oBS��5YM��)��?�7$dCڪ�l�++�6�<N5���{�+���0��d34�i�3��F�]"%f7�H$e"��F�6�L����m��fx��a�HI�����;�]���a�!�e�_0�;{u_1�;����}�`��+�}�`W��}�� �w���S�G��ץ?�>q��O��x'm���K��?�g��V��#��a��b6�V?�S��x"�ƞS)/���|J*��n[�g �*�̊��q��mme>�R����P�1(���Y��	~|u5:�Kc���b���(�r�J3u+ʹ�n(�֣�G��n�;������/�k��X��k0�F��]�Nv��f��{e�d���ҽ�)�N�C]�/��jI}�����k�iKh���D�������������P��Y-\rQ�E�a�_��ik�6#D���m;׽u�`zϷ6Ol ,Q�b�탣��G�:���7XIb����
@�0�WZ(��gi�ʉ�L*O5�l`)�����t�y�J�!��\��Ʃ� H�Co1MSBq�`��֗Y�띰ɺ@�[���<�����X(�L�>}��5\���Q���MYWN~	K <�g�6����[�|��sr�hP�90��(��[o��p2>Opx��=W[�1���h�x�hU�Ǹ��&�W����7Γ��Ƨ5�O�����G[͖?�≵�a�8xLc�,�p>����9HT%��>Ƚ�q��9�R�x���PtR�R:�!^�n{���b\�/�ro뫛Y�3>ZE�G�)�C'����}�I��U��ܓ�p��yc0�&h��W����ĝ��,.��O"���9�Y+�(�[8蒿9�u�r���������v�~�g;?�ٿdc���f�f;)C+0�@2ފK�L�$u�j�p&&��O9�lk7[#Zq�a�6]٪A!��%Q� q Q�e�Dl����H�R�\�w-d)q�xp:.�*����)?O�F��ʏ�Xz�A����#P���Kt��a9�L�a���,�}��;�����`x��ςP��?��#A/� �;qz���r}jA���w\F���xfѶ�}��p���n6�Kѷ�5�l9��t�͒�M��r�y�ú<&So���ӮRz��J�0�y:N{�vA���ڣ	 LvtxN7�x��B���kkMA�oJ�bb�pp}��������)���Bt?�45��j�(Ug�'Ѝ�KQ�U�Ǚ�hB���0���-�����M�Z�^dh�Cvv�z��6�R9���s�>����%qE�=DͿ'u'2��^��T����������Sc�"���B僡�ղ�1�%
���s��!#��\�]1�-U*!͏x2��Ci�� u}���XE���2_�|xc�i���G�k�_��;����~}�^�H���C�W���C�W���C��������ف��a�o?��!���?!>���    �������/���      �      x������ � �      �   ?   x�K�+�,���M�+�LI-K��/ ��-t�t--������M�LM�Hq��qqq ��h      �      x������ � �      �      x������ � �      �   t  x�}��q$!E��(��)�Bh����vU���.�Gw�|�������O��KG���"���"El)�Zo6���	r�`���㨶���F4p�jQ>C�GG�]e����h.D���Ą|�w�unZ����>��qVZD��3~1�ɭ�����>������&��RM�{�c�|�9dL��#�ƫ��%zlf,�YUܒE}��VU�uO�49 b�Ux�1�mg� �UD���h�7"A^UA66ׁ�|#��xqo>8�Y=�yU��T��	�
������GH�Uŭ~:�k� l��&�$p�"�FqT�f�o߂H�Q�נ�N�F$�(��\���%�9r��ބ��|ͧ������.�yLކ׊H�OU ��f�; R�����9|�.���bi]��m�"VUA-L�	*�>�XU��3�_��Xe���ٷy�"R`U�ӥ�[`��+"VUA5}�|�+"^�4��)�n�ȀWWAV3J�ۚD����@���[WD�۫���e~5�ը6D� כ��>9���ΎZؘ6�,޲u��.�h}��`Cdf�ڙΩ|@d	���ĕ��;̖<�%�9�l���U,�k��}7"���G�      �      x������ � �      �      x������ � �      �      x������ � �      �   �   x�}���0�ai���Z���Èc�'`0���,��.�w��>Q#C��
ɭ^j���nң��2�4-�Ыպf�Y�K������B�V���B~`1`�*��dN�P���v��`l̜QR
:~�&�p�����[��}��(�d�����>�ZW),M�1��	
=eq      �      x������ � �      �   r   x�}���0�Rn��GD���������h�eGl�R��C<���]ފ')[Vh�[ɍ��J�8Sm��^��V��)�п�'�k۟
>��An�^�f��_�� #o:<      �      x������ � �      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x�ՖOS�H���OA�'�=���7l�I�
�TQ�$���oR|�m� �Y��TmT>���߼�VT12���!D 5�[(�/�)2}9��4�.��HA`N���6؆��C��F�K�5hGb��H^#Y�:�[�����m��p���`������nƣ�u:I:_��q��H:��l&�xt�L:�a3Y��I')��$�I���Ƞ��B g�%w/?����#��!:��P��|��Y���@�!��W����eq݂��2�� ��1Y�b�3?��ڒ� �֑�Z����B�ѻ��?�|>��S{���_������#
-|DJޣ�8�@!M�s�E�֑�#�z���2�� *���mlu�$��U���E�ٞ������a/�R�)Rx����m������)R�~���[�)I�H��W��"/�2p�QYa��X���:�X:�тfo��4%r����W��lg9�v�mx�s�֝��=�0V����T���bŶr�/��m���ā����2�`�1��)�G;�b�����H�f/*��C\�����o��t�^�[�j�A4���d�	[�^�j+�%T������G���9��"�z:'u;΋٫��SD���e-4��F�J�=6%@켑y|�8�
�rv���]���3�1��]e�r�r�E���Q�5JL�diY���=���e����B��<��ԉ&L\4��H���6���t|m�/�γaN{���	ק�� �A��T\��S��&�Hk����I;i����ٻF7)��Q�~��K$�PK?S������n�x4�G;[;�w2����z�\ɑr��k���%©�F ��U"�Cg
 �c��	|���E0�qdKM�0���E�V�A��<_�>�uoz�^o������*	��[��?a�      �   �   x�}��	1�Q��=��Z�q`B|�f���v+����*��0�d9Qz�L��HAmɷU
��]�j;ҫ������`����ٻ��R%���a�i6%F���-"���Y�b�wAsd[Dq����eX����P��"z"zHyV�      �      x������ � �      �   ~  x�}�=n1Fk�)�&�+�:@�TiӸpa���ھ���xwVj�y�'�)*T~�_^Ο������Dل)�V_!*�qቄ&�xh]�B�t�ϧ���������g�Dݢ�;���d�9�X��A{�n�r�B�R��6�<!6�&,�,V��l^t"�����K�%�%�z�Du��HF�K�s�bs�8�k�s����ԹF*��.��P�4� ��,������v��ԫ����a�1���?ϗ�;��0��h���u����9X��q8�Q��0֘��k�
�"����~�1�ʚ {ҝ��G�u����Ā*F�'��v����I�
����B=��b���t�롴+4&����J`h��B�����"m���*�Ss���7l���'y      �      x���[rm�m���F��n�oDF�^W��T��2�|X�Jk�OKǮӒ�#� ���K�e�2��3�^%��1��GV5��Z�K�?]56���si��>�s������������}��������S�������/��?~�������m�?~os>���o����߼����3GB>��S���V������������_����}xy���CJ���޾Nr�u��!%��2�\Z�n�S�5F)í�$}��@���>����e��e=:��?��WG�>9��y�V�v�j�3���
ߕpo��K�Qv^q���:�ݧ�gJ>�x4����Ɂ��X���)�Z�K%��Ou���d�S�.Ց�.��Ezrm�K~k��@��u���I]�O(���,��ت:B�Yu�\CUG�1��j_}�5{P��y.�[kqn��Q��c.�hJ�JГ��Gz�HR�8]�m�^ܖ��c�����%ihQ�C!��V	ɏ���y�����������O$�2XC�Ƶի��PC(����+�&����_X%�)S�WBn�p 槫Dk=�|)�����(��J���2G/��)�ٹ�19�3����ۅ	��Z"��J���D��өdѣ�z(ZO��K�{됡aX���f^<ouLOݽ�U|�#,B(G���OVDW\�H�!?�ͻM8k89��}�{Dmq��ju9W�HkaFGjH���"��ܛl'd
���֚Ԩ�@IUq�C�)� r�����-���k���)���]��z�>/mU�!k5��fh�m�+O�ӻ�P�2QBR=�`X,�!2�/ɥ����F�.����g
Su�Z���O�{2 ��P����4�LU��S!
�@+O��{�D�(.�Lk#1P�J,R��|5:j��A{��v�_���!"���Rz��*�䁡1ٟڊ9u Y6�n�
[ذa������� Lk^ed<xJ��<(�.?�����^&2��q���X⃠�n�\��;8Fٽ�ť���Z*8�ˌ	����X�"�{ f���]�� Kz4O,w���p:���!o��Pb_2[��35œ� �����8����#�L��|��`x,�ڑ���K��6n�-�Z�^��6�Cm�|{�+TDJn��F�j�zM�א��d�,����0�a��RY��D��`5��Te���?%%�,�Y�	�
/>���YN K}�������왥��sԧ��a}��=��9B-3I�#�2��T�����Yj1�E0@�P��Qz�@	�8V���`I(5G*���pF� �BP����\� �r��<Vd�e�Ҿ�&_���(;��Rh��)�牯E�"�E����Yr����I�I�e*^y��ı�Q+jK�S�2�=c�TP��h4*����A��8,����1>�SV��MPV��?U"5@KJY����J�j�+�̿��G�,�M����ܳ�$�^���}:�����]�L9�PNp��HL$e$�M�O�ZYp�f���F���:�f�%�< �A������!��(.��s�2�\Ns�9��nv �\#.��O������N5�S�
q���K��K���9�p� S,���k�#��
?h�4Rm$�Ј%�u��|sɒ�'�O𔠔M&�q{�K��lA�`�OGও����@eN��ƞ����YJ�{XF���Z�$s0���G���m���A,�{5}�b2n|��X2s�@����c�����%Pu&r P�u��Hl{í{�)��Fd�I��B��^M_&��L�ƊЙ|7�$���C����G���֮Tk"�_j	�	�8�9ww{�Q�������h�B�|'��3��*�]ѕ�����a{@��������}gj����T�?�S�/>|�/�4��H�F������<�4���b+�<��yOnw0q���!��!b��� �gu9�WSL�)�n9΁�"t&*�%?Q$�Ev�T�\��}��΋A���<{�Y��^n�δ<���K_�\S�$c�LP 5O�g2z�����P®�,����D�%���1�P@O�۵�aRp�{���р���v}�����O �r�D@4�&��ꪣ���I�X���O��3�����(|�jY�w��2�����&3J,��/���p�]�D'�������bk]!�Ff:JJ��b ��z{�7�k��A)ަ�2լA�d`L �qR1��րo�6�P떌��IӀO#)Qgm��|^��5�h��Y�5�{!5�<�RO�"��1+eֆ
m##�Ri�"�	ކF�f��k����m}�P ��s������^&h������� b A.��3����� qRd�[�,f'e��G�Rܖv�: �gR��Dz� �?x�M�i}4I3I�ݶc�8�EE�(���pS(P��d����aK��f
p�Oq��E��jRG�"��Hi�a�-��ÙI�=�8<�f����@�k�E��Q���/�T��dM�h"�s>��|a��5ۊ�!��amDKʕ�W�i�ŴGY)>NgC:0�E^�j��4�����]��L0w�>N#��x�." SQ��9��V�M�d���	6���fO[n�Q�n{���-��7e�2��Ȓ�W�c�{�c���
��&���X!� \)������T�!;������EwBE>E��9 �h��q��X&#2󎨲Z�J��`O:c[$��<���"��D��"���ګ�o֢k�
q� r:�rq���ƈ��Ho�;4��ԭ�-&%�IA�5حM�e[�?t��R���T��0�e�)ãI��z��X�:�`�+����m�#�j�۔톂d5�Y�|)��@~���}����uc&}JI%I��"�.{
��>t�D'�A5�Ծ�dJhu��B;묫0xu��`�yu6��R�&F��pp����k�N2���Z�nBm���m까���#�ip*`���rc������&.�B����x��� h�/!�9(?�w�(�-=S�r��Am��v��7Α&�=��.>+�1�QkL	R����@B]�<��w7��/�f[lwH(�8HEm�K��5��Z�d���O�E���e��F'.^����qSB���6��m�=��ڠ687c'�ԙ��h��'"Y��[o1tY `��Е��ښ��]ȱ��ѻгRhl˛�I	뭧 ��i;�݋�%N�X��0��)ȟ!�a��&b8�6�W)��C/�w�D��SC�$���󂢆����(BP`5Ȍ�Oq�H���<��F).JP�``G�>l�1NR��O��������A�4��hiT"p�;�;��b�z׃f�>~�~&��T�D�� �G����Y��)��"$�׺�$��薏����f&Ҥ6�ާܮ�ӛ�)v��`!A$�3��Τ�G�]�f��~�HI�HH]���Sl!��֠��C��ۮ���k�v��*o��2Q]:�q�Z!e��P�����`�4rc�f\��۱S�X�m���򙏼7�5����s��#E�J��u�CX5��r}@!�22�Jꨞ���@��h�l�i�-�bk��Y�~Jxz����Im%�D)ʥ��F���ٹ�U�VM��dgGvk@���5v�h�Ƭ�7W����0�uDcLo��2iBݜV늱��N��x��Q�&hթ�+�YFe�P��V��.�l'4ھy ��mvg$�[)���އ�N����I�3i#�c0�n$��[�8f2r4A�Qs��2Cy&;��z�	l�C��[-zm���CQ�������!έ�VSJώ�����PQ#�ۄ@�ӭN��)d�އ���u��4���C?�S&W�d�Fm�ÒZw�D�To\.ǝ��:[�kƴw�$�_yԅ�}j)7�=�a�w������@��>"Dl�V��oe�E��P
>��نU�^b
�l�tNWTe�1��V(N��MP�#��ݐ�D��&���3�JG�gj˃}�@۵�̣C�*ž,�evہb�g��R��^g��õ�Q)���A]HNl����e���>x~��h��`�ğ    9ը@�Kf�T"�����e
<�cѷ��H�AY���i�G�X���KBG���4K�E���/���=��0�=h/�ַ9�Ld_>n��j�G*w�Hv �M@�1#:���Ղ$���ބrT�uo�P;��'?�V�*0�Q�j�)�lǒi�n:�ö���%*���7U�YrW`y�2��-�4��9���i b����;ux�x�)�TL5���v�0o['qQ�������ɎOk4)�B�4W��s�� `�����ex� �����H�/E�!�#�Yt�E.����d�!{�BJт�v0,�j��7x�����v��)��b*ΐLl+($fAKn��_��K��aG2�t{��9X�'A��7��py%}Jy��]y��˔*��<�٠w�f�!��⩡��	*R(�ma��at�iD��V��@Bܽ]�[X��#��{5z��ϳ`�X��A"d��%󕢽K�'�WIs�Y����9m��mH�bK?��P��3E8(����2�S�Q�ݖ󀴖�-&2Bu�e�ie�$@�s!�Gی��G5��+jL�~��/�%��Y0`��1�Vy�����ь2Ԯ3�5pb����šh�dG4�t�/�e2PM���˔�8�م�S~d���P՘{�v�RۃtG�o� no�-�T� �&\��@��5ի~�fB�AQ�[���~��5u�K�C�������c����4��J˶{��}w=�r��ڽJo�T��^�˔ ���r�i��\c��x����c����ӂ<.H��O�V�cz�G����G��q2��.`J�j~:�+b�Vܣ#���	m��E�c�!��ߘ�/�H�^�O>�@l�v���*�X��t6�l�����6�?�<�&�4,����H%3��"�/��yO��5#����۸`'��30��;:�L��Q�_�I��>��.�������9١j[�K��[|ߥ�:v݇Yq!eo�T;A��ʛ����Y�Iي���%�ݒ%��/}5�^U@&�F�ȗ=��`FӦ��: ښn���MϿ��
/��<����Q 8�A��lX
�U*E�����ƆƷ����Ø(�#4�xi���ߜ�a��zȯ'��ɃSʉh�)��(���R����
��*3�e�"��,�`�5��.���Z����5NJ�3��&���T[� %�@��9um��";�*�:k�h3]��ݙ�i��rmKm�[����ǖ�A>����ks"���pM&���T����c��8�/�}�Q����	���v�����;_�n�=�_K�/&`;�J�V).��R���i-[RAvz;� ����+�:G�j�z��JvJ0�	�R�%]�+-�`�V9�W`Ŷ;?������R�X��7!�������]}8���Im)��%�&�W���ͯq�K��8��2eԕ����c'D�m$Sa��K	9��xU�Oq�8�&'h@�j!ő�ϭw��5Puv^���E�_,�v&y�;�(���`�5�=ohm����f�#�K���~`N��z�����6��=^&��p<(�K�ή����
�Dϫe��(]P@Q]D?�p����61+)�"xh�m��%����/��'�H=�p��},iv/+Խ2|��N�}]�Ϯð%2C��&\��?�F-=���WF'Kx��˔K�E���%:������plY�o1NL�8B�#��NBٛ֝v�v&$-�l��Ղ�gI�.$�b2BS��׍dHw�C��p��'f+����k[$m�����lv!�lQ�;�vo?�.Kv�="�k���e��y9�U����׎��`�*�{;�ƏC�o~bpvD�mv��Ҷ��w�IF���5P8i��z4�X���p�A�@���I#l�9���N��Oo9%�t��zf�]g�s�^��;�a_(f�']g��M�t�ZyZo�Pݣ�^&��	�����Y{�2�.����v�W!{C	��ؙ�[{ʯq��иom&�t����\�jxXS�4!o��! G>������n͕�f�fU��}�wA*���]ȟ>�鐪��L$�؃<�`�P�1Ԯ���m�Kwo�E��>6^Z��ֹ��]����i���.Du ��h�e�	�~�IW�⠑,.�Dl��m�꺓 S�����v����r��̄���AX�}�5�
���6�)Y�:�Qn2�%/��ˮ�6	>�b�C�S��X�#�v����1�0�~kW�k�����r_&Jw:��Wۜ�Ո�ܛ����LR��sF��C� ��Pg˰{�H	��SMk�uۅj�}��Z���d��7Y��v�Pb�[���S��\T �$Y,e����jw2Ä�����{�?0:k����>�L�Fl5 ��!�N���,���.�Xg߉�Ő<�R@UgG��}޹�7[2��7dx��)9^�W��i!;c�ւ�U4s��
˶���]���ﮆ�v��vȅX�sz�k��=S!>`*�gw������.b�1��B��EP�&h���0��eB�	y����h�!����b��`�Z�M>i����o�t��깐�D&�i�s����K�ԋ���GXY���L����������@���0��p�RAnY��s�(!��¶Z���Yw�%�yIQ����զh9�Lpa.�^);�E� {j{ȯ�kJ/�mO1�^� ��\/<� ��n`�n�g�֭)AN�D�G
����jw�J�uޅg����K��6�l�؎%�f�V;����b�j}�,d.S��� �xHx�6x]",�چ��
緅��D:{9/fX ��kj1�KAX��h��`x%4ϳw�
^�4o~.����u3�իo�p�l��]x��y��R#�a��Q�nkKJ��n,I���h�ТM[�?^ۭ�-_Le��З	�`r�\��Az��R��$"����W��R�k�.�µ��1�����}�?�k�bG.�8���r��}�W'���}i��9�9�p���;���w��z�-��'����GV�Q��VK���[TrE�ӽ����_-�ңj.�R���X#s�,yR�\Y���aٙ �~.�	�B4�j߷S���@,i-0YC��L���I��'�-u�^F����Z�aC���O!N���u��b��[�����zә����~���z��WB�ǰF�]�j�P։CV�l7�;��]Ýb� �h��hk�:(|�Ү5��� m����]�S1�����l�<�B6{�_�2*sSZ�8��It��;��������LD���aLD�P�[oWK[�P��6��G����X6�ى+����_+���ah�i��S��y��7�-.S��#ɸ��؊�C��h�V���ÀLSl����!�9eY˩�m���uq�"������7���Tc��i����%x��G?`օ X�~6d�/���Y���Ĳ�LB��$���:̖(��-�.S�NG�t��1��؅5����W�3۩�o�}#��M�Qu�Χ
?g~�]��C)�z����A_����чk���c�����(�gg�\)����zV��b+��L�y�|�^�c�^���a�ї�����X�0�t_��%�T�@bA/xİ��k�u@!�UhMm�B�g��z���v���>������.��vu*�ުu[���m�ɶ�5\����F֫J(W�T���d���� 1M�>oe�2��KG^�t�c��}}K���XK $ζ~��3m!܎�FyJp�"oW�5�&�j��I�y�����7�>;�@��Z�5yl���w���=t��v�x������5>A��oz�h����|��8�-.�Ѵ�v��j���� ���B�����R�S��g-E�*7�Ҭ��FA�s��`�7��ܘ�9.���_���Ŵ{?���B�l�O���ߕ
,�J��~�#-�r�0��΢�Բu�<��)V~��w_�v$�cu�\������^4���dחFM�֦s��!�YC����c\z�
���}3��ո���Y��q��(�r�����fhu�� �  	�<�Hġ�H!��y���(����t��H~z}�K�)�4��&W�; ׳�+���|o�خ�˦�V�9����T��0fPs�{� ����]"�.��`=ߤ��/���UR�܀A)��RtS���s��#���e�i��S� N���6n�L�k��Hv�m��2A6±��Տ�Î2dk 1�ߡ�imԃ]�S$ۖ��3�il���n��w"�⭖��7�E"�!����3�0ŧ�i�}��4��v�mքv��N[Rي�D��qa5)W�~�e�e�?�酖0��m���VC���hRؿ��jJ`���2
�1۫W�\M�em���|h���=��� ��Vkl�K��&�h@�#ߥM�z9E~��'�k�$���7��5��êc+��i�v�-4ow���I�3&���>d�1�U\}��l�U(��s�H�z�	&[���L7��Zڦ�Ģ�Y�2���c\}Q��#�9�q?���^K��hB4�󝞫ǈ�����\��-�:2���}ƝD������k���.�j��h�Z'_������/��ȫ��d��. Ek���W�=ŀ#�$�G0O�=� U���қJ=�A��z���;�a���u��2���U�F��n�ζ�|�5Z�X!*�H̷5a���a]�(]V�~��ZM�M�����8T˪V]w��V���P'\��]����֬AFu��5<pam�	������z�ţ	��ǟ��Sv�
�l/4Y� 1��������7��-H��z��6�n`�:d�kc޺^��\��L
~��/Sed�K��ҍ�@�o�Cs�6;k��%֝�(F��nm�)$pE��殓�
��K�_�b	�|�%3Y�g�O>\:A����1.7���:(dt�u��ed[cB�b�6e�F୻�ć���d����d`z���U[�c�yfx��溳�RP��Oܲ��w�eE[d�֣V[�a�E@��탿^q£ԷX�L�;�|I��jky8�dp��%��E��{�-�鶖k���Nb�i�!]GM8��W�D��{K����÷R�є��}x�V[�v�L��W��@3L8F&C�f�����l����8�4��v`��ڕ�ͣ��sx\��Z�؆τz.kG���0{�IgxI�k֌}۩��1?��do����ToS�����Cy+���;"p��(�!yJ�io�u��%]���1��e���j�,݇z����ճ�;�{��m��j�b�%���dK��.ػO6��5�h�A�Kݾ��~m�`�NE�⏻��5�x�WS�g�y5��)�J����s�>�o�Ke��I2%��	�D�hFp��Z��e�v;����eu0��̽L�.+��)Ŷv����0�1�F�e�:Y��)�@ZĴ���0���-�o9=n!.x*�>\�d+>�U��z��25�W�}t�T넂���л�':'�z�wM��o{�Q�՝�k�>�{'�C�ת��9��Ն��v��h��+�禚��zJ 嫏_��o]�
�(O���������Z��H���\&�kPGfw��=���o�Pcv	�`�<)�Y�QM{���۶ʽ�d'om֩���H�����d�!�MC�v��I:�R�W	[�`x�a��I���$���[6J���k5#���֭<�~�|��^Qd�M4�)>���G^�֜
�؇����Ǻ�Ϸ����Q^mSk����7�%w�o�{���L��G��d�I�Z8Z�/4.{���]��f��R�v�|�VYmu��}d2dػ��B:�m���@�:M[Է�����z��ɇ��{$�(��@���N�	��Hoo���T�n Y��Ŗ�uM���f�<�-H��>PZ���m.�V;ux��k!,YFvѫU�Zop�������v	�ͼP�\�+mq6�*e;��l�[׶���P�/�`^&�Z:�i�WG۞��w�3|TKڻZW$��.��8�ސ��M�5_�͇�P�]�խ�+q��q��գ){]���������?�le�      �      x�}�[�%9�]�O��'pH�1����	 @��km��?zTe�"#��~�n��Fi��6�
s�ګ�S�X��b(u����ؖ|����z�������_���_.��������o
����?������?����������������)9�:'̖��e�k�=Y���˭����g�^�Ikt���Z����u��~��x�m���6x��}Z��wb.Φ���hu��`��x��G�!���2l9\�cpk�k��ep�'��������f�y����Vj۹���R�NyE7K����ۏ�?����n���'��'�q��Nd������m�Jlɥ=�l�X��,l���w��+��|��������n�g�����S��8����lq��$�crť��[���|$�?�;n�c����z�j��>V��\���)!��w��y�ޒ���9�V�F��Z�E˱�������o	L�ݶ߅g��m�q(6�^m�����0�R���.���`��' ���}��ۗ�/���Ξ���ܪs�e'�eхmD��1��];���]��&!Xj������}}_�����	<��'��;�;��y3����l{L?j\={7��2�9Sn쵁��f|�@ ��7�=��.k����4vt�F
����M��ȶ�S{��x�V�$J�b��{���}��H�듷z?x�>��se�^R$Il��[�l������Hao~ĕ�'s@������j���c9��{s32�$�R[α����Oy�ɇ����?ȭm�]fm���_�}��
���/(��r���:Y����5���'$w��pw��g�n1M�08��<^6��M������?D�>F��sZ��d~;g\�f=���R�s��[����lru��� k)޲/(�C��y�o���]H#�Μy��$�@�3@��։�y����񱽀�ǟP����o���}6�7A��W6.v�U��R�n7�`����H"��i��������!w�{a��� �3a�I�f$�-���&4�3&�W-A!w,��c<���$��������o���>�M�	x3�{B��1�n�M7��\L��:�{����(������
�_�]C�i���l�pzv�]����-s��QV�S�<`��-���i s�c�迥&�2�9����@���9jh������g��=����?,�8����W�����PF���M���<�n�'�[��
��vU��i��f �|���}�B��
�&ԋ���'�Q ���U���Or�e}'��[�w�exr���>�/��x&ԋ����G$�Z<�ǎ�$�r$���{�m�;����?<H� ��J9�����C��M� � �x��c���E��dJ��3	�������J����;��_�^��ǡ�l��yJؕ`��KȾX`�Z��l���8��Cթ+�y_̾�)Xo��b�$K{/�gP%�j.��Ͱ\Gs�UKQ�A =iA=P}��k��|tsMק�%�9-M�L.jtUGX2:����������:	�UO�'�3�)���7���L���� �(r�!�����E�{�FH�Jg~�F��>t�����}��@��F���:4�=�b�@~D��Zg�R۹�c�Z�pb�g��zpm�1����k(�͌���[2�O��̒�NH}�hn���1zS����x1���Һ��+�
p�EP8H,|v�^]9[��Eە��I(�tj8$G���J�"8�����ҷ�z� ��,M�Z.o"r�2.��v)��!�=}��R��h^߄��?�~���l$�mx�^�O�Ոu�i�O�\q�i����������a �l`�^�>&8�[C��6|z�>}�p"�h������X}��Q){�t�ą��M}l�ʷӗ������y������-1e"s#�Q�|�o����NceJc��,f��^�>f���rE>܆�c�8�X���d'g�\v�ea;zg��^�9lX:�#�͸������'���07	��(��s<)Ϳp+<[l�N�e���H[�c�E:(�H����ŗɯ7�K�|� ;�|�a,<�
[Ćy�jKr݅�lw�_<u�]5d���}�o����x����Q��ʄ]*�h ���b��g����ɶiq���ذ?F���-^#O�_�gnp�`/K%��u��>rS��j G!Ciԭ�O}u�t[��±����dn�W�Q%��
��F�=�
�؎�p؛GU/��l����L_��'9������gAn���ֻd�XG��'��u|/�V��l*O�C��K�|����3��>����b��v�.����,�+c�JYh��V\��`�������3��������Y�CFtHR���\wS��@c��a�y)xʋ�k;>���_�{�ݬ��f�NcJTϰ��� �ͼ�a���;�~���"S��Bz��I��M ŵ�����~�ٶ��l�6����>E��x+�����ۭb>i��φ�Y�?�7���\u^� ��r#U|E}"-��κS�Q�������e�$\�_k��Ag�f1�oa5F�
�^�Rټ���Uۍ
�#j| {B�6T�G�pt,�%��Ǜ�J#�M�L��w�0 zC96+:f�"�,��ar�ު�+0�ܿP�3n�)]K;�=�5b��ȸ-v'�g�,��q��M���jv�eR/�كz���u؜������SX�ؽ����6Bʑ,Zi���Td@ؓ3��b�w�ZGP�{����i�+
�������pH�G����o��v��&8o��4��:<��D��X���ʋ*�Z��]&�	T��8�{��/%�&A�"���<��v�}ǜ3��ϝMܸ��'��Mܫ���nWD�?<�@B��+������򟈾B���ᡈ*ޘ�E�#{3��h��H�v?Z�O��Zt�`�^0�\�LEo΁��Ȑ	�`j$[�P{���I� �	�;�	x� ᓮ�}���+���&��F�!-��
T.�A{���vG��-�8]9���0�uA�[)Z�k�'��$!�W��QV��B�ч��t�Q�M�&lX��?���c)}�'�+��4����r)��NLG�Yw<ڄ�-���Վ v�#<�����t��5�Ux�,�.�գ9[ҁ�jL�I�>����%ܽD1İz�|hHD9�v��;�� DӀ�	���A�%���k��P��
V�>�P�
GO���n)�r���ՙ'PU�ϙp�n�S�����vx�ʎ��n�)���N��A	������"K�g�Vu�g*v&��>�g����OHm�v�XPH��P�m����'�"�'$�I$%X)�O  
_	�v=�}
�Ap݂�U����V���O	U[^�$�O��Vc���[W-�L � aˮ���^�HP���s�k"�B���{�BB#�:k<����:�J	=dk���&����xb�� ������)!�i� mZ�B���5�?~ w_w�/���艂wW����Q�7�����
̋�,��9����Iy�A�	Dd*p���m���� AX�@J�+�߳������zf�`Q��+z��f�k(Ǌ�F����U��N����	'n�d��.�B�:g�i��$�Ǫ��cJ��hdC��e�!�	Z!W�����!���K�C|��uX6�Ą�V��Ui�#z�Y��Z�C<,�C����P�M�3YaÐ\�0>A�״!߂��B�Ge�|p�y�Ss�@\ex����mm75)�|=����י�'�욆�"�n\*t�"b����,�b�����יy��ȯ8�̾*����'��~ X�Ѫ���xN�|�8��$�"	����FE;���L �|۵��& a�G�)ω�h�b��#Y#��C!QF�#�׬Q���t����	v�\w�)�A��� ���� �KX7�-�6Y�����~�}�h£]�6VW̝    
�ξ�ty�޴Ƞ��B���=���1t���$���d;��*	e�M���N���c�1�:Zq>Φ� �
�+���C��� /�/��ؖ4�x�	��Q59_��)��Hf�^l������t`Q˽�iن���tf�H��bL� qd��5�Ȉ�/z
r����vmB�����*�Ȃ%CK��h���5�"���?�/B;]O��S�b>��� ~��x�6T;�?�_6�@&��BֹU:�^�2���0������?U����#� ���T��O���D˃�oP0(���v��<��l5�1�����|=�RǕ:<+�Qwv�����'�QZ���M���R�!. {���↭�Ձ&� ������J¸��R� ��Y�(2��0��H��;�\A�@�tW[�>~�a�
�ײ�*��!�'Q��X6�F��[�!O�����|Q^C�SǖY��g���/�A��ʡ�6J����:�C��&t@7@#`�N��{�� 0Ll~������3�`���a�B(���8��#�BG�c�Ŭ��.��0��ϑ��T������0�T�B���F�l89G�J�H�	DJ�Ņ�S�����,�྘�r�eO�2T���{	Mzu{��ڑ�$
�D(y�.�8tOS�0�1�S���D�k��~*|�q�]շ���&I��K^��8{��Ľ��y�-/=*��~��81(���ڲ��$�N.H��=�+B�1�kB��;����G��a���I�ރ"p_U���q�0s(s�h�y� ��z����]�H��jS�+����c%{55���z&��#ǃ#�ڧ8�8<^�f,ך���=Mm���(�4�%�fA�����H����k��i�V?�~�Rm���P���d~��0�0 Nh��-V8ė�_� ��둢W;T���s��;�����ٹ�|GĔ �K]��~�虜�� O����c��U���)��A۹2{�r=,�l�`�W[�f����Pf=�ء��W���Eˏy��/O�/:�m\]ul��g���ޘz'/�B�`� ���(��>X��l�����7
.Oi��O�H�e�Ƒ�� �1��0��ӫR�CmX��� ��'sU�����郾v3��*��Tf��l�f����M�t#�a�OhrM�^zA���jmW���W? K8��Id���0]��g�MQk<��:L����z�Ў��%�Ʊ����S���h&rq�ڃ�2đ:�������=�a���f�+��^{������gt��Z��Π2+r������A�Qb����]���g�<?>t�w����d�:��e��{@k�3��� =N8fuũ�0 �ѷ��W1	���}%@�g��pT33h�%�J�R����S�'�n@��7�7M�eb�\y�����L�@��Ϙ��< �#D`K"?dy �VW59�&oe�Κ�sf�x��	!��{��{��z-��.�<� @Q�Q��
@���=w?D#�>�س�P�k|k�}�ǅ�@�:���~Z#wt*�Ȇ��_�*��lG�Uf�b܉�)j��["���j]�P}  �L����|��a� ��֡�>��jJ�t���b�����3>Tu�I@�#�F��������Vj��qf��)�O����Z-W���ԟ��x0����Ob�+�o�j��m� ^�{b��yl���:� K�`fAu�����W'��ůP��-���@m��W�����W�}��-c���F�&�&�z8��˷VW�]ġ�� <��|�6<�&��XT-�4�!�I��y\��_~?<
@�2@}��N���;�����gHtҞ5��t"۳��&�:�+Z�������h�^��a �x��ߝ0�:�*�g��!��6�!B��E�Q��B9�5&1��ҳhv�B���<&9 �����'N�>be�[ߛQݨ"V�'G�l]E��ߟ?�^}�����������w��T0���Z�O�0����`%u�Xl	a9	�v�K�㧧���� �t2�Ƀ�?�Z ��  /c7w! �C���B�!T@��=j��c���?������H��'�����h��v��G���"ͧ�G��ݰ�1�S���i��+� 0|l��:���Z�B�;A�	�F5�b�h!\��o-2��U���ڵ���Ք��_-��E���ҜU?^w �T%�"��&������Q �)To�?�ߒN�̩A�T�Vӡ�w��er#�ce��橬Rj�A)��m��A�t⟻�S�' Z�+t������+{G��hN��:3H!��%� ���,�/�b���s��!���Q[�h��9^��գ���J%����������:��OC,?Hb���~o�9 0���[]|��l6'9�W"U�<*��n�50�<:9���e@M ��o�J��s�	���g���ܖ�����?8��J��; �tuN�Sa#D����`Z��Z����h��}Ɛ���
��6����}��-Q����H���ѼEH���%0�\�
ހu���PaO���4/��>�o�n��=y�B%�"��J�\;D�9���[��^��R4:
������b��M��C�^}Ry�TѨ)�T�"��:k��+��@Mr�a�m�@���>�iB�i��$�*�T�Clg]����X��s�y���t��^���s(��#G�f�KX��(6��=/Gz�e9e0Kƛa�K۩��u�N�u/r��S�ŧ�b��6E$g�0mt�O� Ÿ7�$������k HM3��7]/B�N <8���{{�� *�I��!�A�<�����ae�)ސF��p�����߻#�n͠��B���cF@��3��|ޫ��f��;vK��C"̊ ���N9�p�65*�o���u������ ���ш���#]���RtIqs�ht]�G���*b�����Ĩ
���gʹ���0���� ����A�Z����t��dj����X�d:����=\@���@�RBO�~�Y�.ZhH��ϖ=e�[�'"�� �>����h>�q��!��!�O����z�\�0�
.��ð�cd�@?pT�T�;�~�a�G�鎄��0���Y;!�4N�s����X�U#�B���$�y��:��6���rD�g������"�|*�gt⩜�dQ��U
�`�i��rZU��k�`�}��'�wQh�W ~J���B�^�yT�>�"�둕�Ğ�~��aB�Pk�"�=	'`�.@]�e��ph����g��s�^�b�����M��hu~d��^��b���G;�K�@Q�����t�S��9��G�y�w,u�a����U��y�n�vh؜p�/'R��sY9ﯣx��hMu��I��և��^�H��*��w�+�:�'xt��:��sYI�z_��L |z�y�����2��B�LQr��e�Up��6^���G(�>�۩�L@\����S�4h�������m��Pg�!+[w�D��db�BߐuW��P#�`>3�W�DY�XH�G��va��-�dA��}�� '�đ�}����|'c��KUa����!I!Y��V��^AԢN���z���u"�W�zV�.�ᑒ�a�=���&��>�f���+WPQ �)���&%���$:�T�3P��H`*�V �Pa�r�%OeH��|�a�1D��D`/�	:��|��:��Ph�l�3���,�N@��U�
��4d>}l���U�8�=7�Hv��@f�	`�QճO8t]��)�L����5���Hjb���4D�l�� ��;9�x<��m�_T�(�Dm��[<��F�k���Z]��ڜ��/�h�����q��\aD�Ya@U
��+e�� ��7��|�ۯ@�&)�;p7fOu
���	��e�~����P��O�wvv	z �  e�ύd�zE�SOx���Dr�v<�)Χ!�ؖJX�$�f�� :I�h`h�P99X��̜_�#~'�(��[��Oa�>r��v�9PEi x+�z�ӣ���6���2��J��y?���r��D�7J<͟�d�qcN/�k]���E|�G�����x��㓡��	��p�/o��I��M��{��Go�8��դ�d��s�=E̼G(zm�ި5����M���ק@H�}@�N�O����d��P�6 �ղ������\T��MVL 4�vg�gx��*X �Z�jJj��tw5�H�͡�ٟ��lkO\��A��w[���`����` �|g�@����A0��]�A��vQ�Z�w��1b��A������	����}���'@��T��{�z�����\���*�&${�����5�'b]�N�W!��:�A�+?�f3��P����s�\w�����>uq���~8P8��$X^��5��A�%��N�g��i˭�*Aސ�}���͘A۫�\��,K>HF��6Dw����g	�h��k�����c���ȷ�+���.�5­(:қʀ��[c�
�����q7��@����~y��~zKn<�4�^�����ҫ�*D�"����Z���zS!��#���:�}��gf��vsBr!�=bx�ǲ����FZ�#�9�)�/�rxi���EJ\�������H@W�38���?�zcM)�'��Nx8�E�n�Q�2�Ȕϻ)�Y�k�jx��U#���tO�+azJ��r��`�q�Ԧ7�)<���!�;5H�1� ���u���յGQ�	�K��M���ԥ��fdy�EHR$�0C�������J������}*����<vE랳�a�v,�V���zo�Ž[��i�йGh��w���O
<�����+{uPq��V��(�6$��^%O��b*o�ui��#��֎��W���*H]ߋ����T�:s��B�-�{��!����PS�:+t�vF�`e�ҡ�	��-����>>*���6Փ���y�p�dw\�@߶�a-����t��Zy.{�5�����結F`�x������swڱ�u^�k�����| ֫���7Sm��]{=/i�d�?�~��T��%0v�"rΦ�!�u��-Y$�ף7���k��g{��4�E�|]�_�翿��׿�?�hLW      �      x���I�%�qeǎU`|����(�YM8���$�ۯs=����|�x�I�ӧz�^3m��V?�^���}r�om�9㖭;��ɫ�m�*����~�л�=�j��\om��6�Q6f�CMs���(a�:G�+Ŗmi��Xm�݇a�����]����������?>��|��[?������㯿�?��������pƖ3��l������r)��;�������?�����m���u�[]Ӥ��LƘ�ⲶǙZ���0�ܫ���	>�Wn��8'���	��0��OS�lf�es�m,��.��\{�{�<�h&��ƈ.����������~�o���?��/�\���׿���������c��/m����G�޼�5�}s��?������?vx����������i�6�Kc�=����+���~��9>�0�0���7l(-U>�G=�fl�a�1��6�������z�~�>�䫰��UGf��]���'�������ѝ��O���}��ˬ�ĔKsΧ��}uS-߾/�a�IH����3[�3n��sYu�����u����B_����b���ĒK�E��6o;�y�B�^��^(��Y(��P��DТ��2c��_-v)�q<�"��J���)u�&��}D3mI ��a�����i��V�9��x�4m��tw�Dfx�B�#�*!�y�σ;뤟�q&'op���K����;|�n��L�-� �� *k�>6����}̙|�1�R�n��*�NĒ�g���W���o�4�d��c~�:�ÄW0�&��ѝ��O��q~���D���6��Fn�^�0+��l��>wuy��7QwX����p��vL�=?�f�xr�2$�>��:)m�`az[���G�/�+.��ѝ��Om\eI���A�q��Z؆��I�#�
�op���G�qu4���b�7�)�д�V��Z�H�A!���	���o��v��a�k^%
ߜ�٧������nv S`RZ�TB��W�g6�n�.���1��w$��B�� w�������B�� �J*�ĞZݘ#)� &I�i��!��O)���,D��I��|(J�i¨�xcj$m��]w�Oc� $B��o\��&}\(�M�g�
�;8R���}���L�̘'m~[~:~�c�7�v��aD�J4o0}=�5��i����t�T3."�;���:��K�|�=t�9�((@^�_&�<l�P��.@�88����.�jH�}�:nZ�����#�g&���&�ֽb���wG�&����o�h�N���2����G�p�'M"q/���%�It-�c՘"D��5|��'�s��_-�H~G���|ׄ��7��&3�|����p��ѭ�.�z#$F�6<WDw��c5���	�#V/D]͘�%~$�r3���D��f��`��[��J���ag��՗���٭�ٍ��R?l"h�y���`��[]�k ���ça@�4���ö++�^��+��bO���s��w�b-m�d{�f1�gt�k����4��O�hPp��yv��f|4�0C�0�eJΥ~wtk��6Ciݹ*�e,t�Q�
� o.$���f�O��G)�%��;RC��P]��q�}� ���CaW|@�h�CO���X5n�i<�ϰC�����0�ݚ�B��%R	��̜�i*�1�H�O� TDo9���n�ԏ��q��A���
B-��ܬ��l%���J��Ê"*����ǳ��CL/Du�B�ݚ�«�v���3�m��2��#��>x��ɠɽ�x�i�{_�9"���m���<���p�=��L(�H���1��3qr���>m��a!�H��;�5хX��%��kW�kK���\X�$��芣 B��Y�ۄ�a	}�Ô�v�p�XC��@���"��@p�L�y��:��u-�W|���Cy�[�]Nntaֹ�I��(4��m�0
�-���!Q�(�<s�L��,��7�Bz���/v}�}��yI7�@���	e�m�9�����fN�?n ^�!��wGw&rf]tC���K!��N�&[����TWZ�J������@��9\�� ¬��=��.�Zs��$�&Z,*�F"��&��@���&"�������G�&�0k�=7�r�e�\��b�
,ç��Pk��*A��q�<��~�A'�EDI��T�ٜ?~@����������6����_�Dkg?�nMtaֺ���r�H��爊&�_{o�Ҝ`����@�g �9�؁�%���M�S�]����>q��/���2RE���7���&ʧ�p�Z��ѭ�.̚0�4��
et����ԥ�-|� �)�e�r�ŜK��fm�8Z-WY�.��s�9D��d%F���m��n��9J3kg0� ���}:�5ѕ[�"-�/�cZ����H��s�갓ۊ��d���� �hc��
9J�U�/��64�߇쐩<�� �=����C��)�>w`/)�$�wG�&�p�h&0E�ye����=mq(\�,°;a��QFoT'N*�*�`���[v^��C�« �A���١��B���3v�+���8~:�5х[����;���P�`�\[�cp�	ʮ���f�A{����"��t�����4�V
M�8�q�@&(���~xj�t��;���&
��2o�wG�&�pk?�GA@zGwpn'\C�"���D�'I�ɬ�!=j}�ճ�yh���aڔ7��<
O7'vM�^�z;S|!Yk2u�kp-�;�wE�����{â�ѭ�.ܺ�)&���j��Y�X�m�A��G��E��!8����h��ń�[}��ȁ�[1�=S����7���0K�C��Ng;�{��>a��a��,����Dvm'����Y�����8fq~�����@1������ZW�vsH[@�܆6)(�:�F�g�pPT/���d�5�)Ba��I >l���&|ܾ����}�®c����''(b�*�PH�&�s�����ݦ��n%N�#Zs��b�#�r� D,���
[��S�{t|ە��݉|q�����0��ʫf��L��ѭ�.p�_�0,j�?� lh2�Q�#���]���%ǟ{�[m0���C1)�8�E�B~p6��l�v�=�lU=	�)9q�f��9=����W&A�@�ݚ�E�(9�4�v�'LߵW�ʕ���OD������_�?�-�����cް�	�n��jz��[��X>�AXf2�/*�@@��M&��������"? 3��n/؏9�nv�� �Ṿ�A1�ìFg�*�m��>`G����|t���V �'�[C�xD1Q��]����H�"=�Ϫ�=��!~���nMt������
�5��+5�����!I~�����i���\bc�5<���qlv� <f�NP�M�B�L�=k't˲H:�қ��ӂ���U�_
A�ݚ�ʭ���@��Vn�^��������J5�麑s�T�z4���8�K#�Қ�-,ī`G��S*f�0��Z%CxS����Y�c^�֔�����[]�z��*ZY�Vy/$y�j+60UHJJ��m�p��9߃0gϸa��l�3|���*�HQh���e;N��Fp-lM�ӍS/�X{�D�2B��mѧ��r��U�B��4q��K��h���@������E�_�K�#���B��"1���T��U�g� 6���1�巎�ف��%���a��6Q�p�e���㧣�|v}��*�"�*z����y:Cl2!���0�����MJ�P�Ԅ;5��V��!�1�=fRd�֍D��d�4]�ORYO�������&�+}:�5ѧ�j gep�\�w]�ә��S�):�$8q�W���W���,��	0�H_��X�^�J	�6�L�<�;b� �����X�lx9�Lz��ף[]Dl٦�������Xk[p�<�6�6�
�4@���_R�q��$��4���ۂc7A���"�Uq�N��eX�nIE����E��zk~A����lFe���"Ԇܝ�����Hmٚ�c�E� �P��d[    �>�3p޻�&L��,��3�!���QùE�P#$��*rn=ϋ\|E��^����/&� �.�Tz���r{�����St0H�`?��o	a�����G���
���!)N~3 y'�3W*����"��D����op�/��ztk�\Ö�ӷ_C�v+�F�4�"��O[��2�K�#%�+:����m�ن�a��Q_n6�T�Y��Z @�ϣ�����37Q p|u�]�nMt-��e�钓�9_�	
���XlcK�~�Ix	�C�v�]���a�b�*�<~��PK�|"����(X96��� �]O?4�ك{aS�ڧ�[���h��3ί�X� ��qj�Cb=d�m�����\�z���3�].NWhc�jW����KnOH�O��Q�؂��������YOe�8��wG�&�h���	�CD 7�@N��û��]HįT�%��8W	�\����$RMlPk��C�Fn�¡-.אxy%`��ɰR��D�O����ڒ�ޯe�G��z2w�*@�7��n�z��c�J�B��J�!9��IL��=v��OU��W�L&ω/�_�yB7��ڪ�3&ra���r���F�g�0>���>ݚ�r-������{@��/%��̀=��]���	��̉��6S��0�8pk8ﶮ%ǜ�[�|L�O��`T��]�cj�Rl|��;��J2_����m�]{>�
w]�JǪaA�B�ؖ�P�S�P�P�:��ͷY�^���3�U�5�0�k#����(���h�����r������ڧ�ށB��wG�&��!!cW'l 4duѡ��M�����	�^���������"�J�8|���%H��z�ch~��I��$Uֳ&Hp��H՛tѼ_�_�n�^�kDZr�m��7��>ʋ�!@c���Rwf Ga�bI#�20=�~��^�/�V:����>d�%7ˮ�Z ���r�5����u!����ze��G�&�$��z=ɛ��]I�)��!}[��ӈ�8 3���ˤn�;Z����z(�m��x�e�\Gu1�f��"����;C�����_���d����D��D4t7� ~�-��Ř��Hs絬�+�xp�x��T����z�����.�A��*�Ac���1!k��?�s+�d#I"s������qo�P�W,�ttˮ?51(���{���\��c�L�=fԨ h-=�n�8�k�1<*�NM���Vsh*���'��\p@�E#C�Y�1�����$I�VPξ�:^�nMt�h��9@�]DX5�i(�6�LKj�:@�w2I<����Fe�����6r�!��0�=�#�v�z�ЌYn�(M=�I���O�����h��w/�ݚ�rw]���1M�+�H̄�hReu�*�C�Jz�Q�vL����Q���	���_qֈ���.��Tl��a��Y�Y������(K�9��nMt�"H:�}���Tf��5S7�Z=�����9���S\X0W<kȑ����G���Av8l1k�@ř�W��{��y�y���~�D��%���ztk�� (�h_����mBA״�t����Y��t3��	@2�f��ƍ���̃]�����l
j������\��݆�Y�|��� )�rݛ������ѭ��u!��&r�.[Q'��u��i�W�=�4��c��eV�	����pЈ7A�\C|��̏7�{t޶�U��yun���~������7�v=�����:��Yē4��y.��o�zZ��?2����hv�r�u=���/�!D���<��#n�Љ�w>�Rl�� PirXM�6����h>�}IJ�u}:�5���An��z�oΔ��۴��#�𙨒3��J�ښ�P�PS���0�\��8-�k�ty�G�-���Ui�E�F�"��ׇ�d�������?ݚ��H�'_z�F{�X��M���j�³��$7c�ţ)p�Iu�!%H'��W��)�$���m]�zn��ZC�����d�9���&"��Z�~M���nMt ����a�����LD��O׎$I�tus۽Nj�")#��q�n�����Jui1�+Le��X��(SP/�v~��
*i�aY�6���5�:�5х]��F,�����	��NtE��m�Y��c�� 0n�	!�ve35��aH�����N~�@�������?\v�'����:Fu.�l��~}��ttk����9���	��ihKJ�]�����M�i39�%o�(�dX����e`�L����a,�������%v{$H'����Q���&r����ttk�t�E�AC����5$����w����F���ka��r��M]�3�CﳃR.���N��߬=`����zЦ�2�d`�5b[Oc�^:�Ц�7,�ݚ(_M$��
� �Ę5fw�JdgU��R�euߪ�U����� h4c�=*�Nģ����:b�;�j�^oc�ݨ�<󇙽UP�7Q����o�ztk�kG��5 ���!d1�Cg�<�E媂�H�.�j��|�64[��T��5K�y�C�����2H��-u҃�Zpb�����̞�Ā��BCb�x����Dv��:���%�0I>K�3,gM��o���dl��������# պ>P���I�6��� Q�@ׯE�A:+�Fr>k��{��h|k��tt;��®��(*���6� �%�:7�@T_�O�L,�@onu0��P0�(����u�X�A��:"�@DQ����[31���/ ��~�{��ttk"{��G{6$�x�Z�Z�{cy�pU�ՀDS�P��*e�VS�T��W�#�ge[FW��A�0 �|���]�iEu U�0#���e�����=�_Nnt-��v[u��"�mu��/z�Ic�����p6V�^K���w�)�I����6�|�{�J�2�p��؁�Ef��1s)��%�nu����޾��V�����D��{E������-��*���SJgg]�ެ�NƝ�ͱ�TQ_8l�̫��R��,��tޡ����Qt�b?;#�g3T"f~��
-�@۳����[]�5�v?hc�:�4کHx�OuI�A������4�0MhOOG��i�c���J�;/�l��5�*�w�Η���Wm�'�֧S�Y�f ^oOD��nMt�����VP(M��p����T���;�*�ɵ����� �E�D$�n,��	����"/i;�RZQ޽|V�LrŴF7�9z��:��^5�V�����Dn�	a��ҵ;,��B���X��+��ڶ��UV�)�0$�zs$�KN�3^�W�y�o���d_}�~��ݵ�$�	�����yU]D����ѭ�.�Z����ҷ�KDr��(�bhDRږ>�v4����`m��õ";�1��Es�HzY��3 �Da�V*q� tv�́���tʯ>���_�~9��2waE��3\mU�V5�TD�3�*���F�E�A���E���2�Ф�BM��ri�
�v�i8�wAm�t�haa�ȗU�^�a���(�c"�|wtk�\7����ъ�m�-7�V�^A"�T� ̒�P���\t�����P���h$�H&�u�l�|�B>qw���ޡf6Q��@��n����D,
	t^)�h2�NɝzD�&#Q �)� �AT����;���,�I�T�iYF*+���$�kd�:�4����*�i/"m��&J|y��rtk��BS͘�q�7v^�A�;^��Eͽ�t�8r����ף9�ۡaI!�b;�8c�M5^cBQ�$wU�5A��[�"�;�J�x4��k��D����~��^#A5<hVq5j_mh1�A
3�?w�`K8���FJC��&fiT3�ӫ��҈������a~E��!��`I=�n\��ʟ��˺T󛍮G�6�\�xR�Ҍ�<�.�I7��牪��Ԫ���W}�&�'� z�4��[�p��U@�9Á@�N�ƙH�S1�f5�ը!8k��G��� w��J��;���6�_Ld�9�����z�Ѝ�Y��rjl8R�[�    y��J���v �5aF����.MM�q�%�4�Ʒ��h�欺��b�z<���_����S㗣[}z��0���1�W��P�YU#�KF�k`, �[!��q��n�Q�#T�zλ��Gܦ��`RI��)G�F���K�Ț���/��n���>��_X菓���׷�jC�i��_�B������8}?V�1Ԗ_��āƷN�/�z4Ӂ^�K���^ǜ�/q� w�v���e�k� ����j���c�ir�T�e^ȗ�[]x�~�Eb0���dL!52s59�]�*9�ąUͮ�pO|�-Y��RZ��
��#�_�n=l���d��I	���+$bH+��0'~��w�x=�5�E�xQmQJ=��zLĄ���>Mʸ�pլ��h`�ѐ0o72dd;�P�c}1;aԌ����{�m���5vC��$ٺj
Y윜�����r
W_�-����-/��5QD
א&k7I_#��4�ы<�&��V�A�ȆFը��8�'�#Q�f`�i@�*R5�j�fPޡC������9�z��Q��a��|����>�_"m�J���lE��V�C��04���{���j���\Ň����U5��OH肋�^A����_�����fZ��V�5�?���ab�j���|G����rc��.F��sC�\�#6�T9���=8Cs洸V�������I ccV|PYN�T���!�b��;�J͜���zr%	�U�}:�E���>Zc��lj��ֶL���E�iZ��v��pVv8�=����~�sA��|f�\��U�� �}���;��n��^$�)aT��{<���2D����_�nMtQ ��=�7���a)ЕaC!��B��t?oWA�%��rQ)�ԑ2n3� �U�m&;&ug��FA�Z��2c�u�B�j�Iv�Ѻ���Wb}��ѭ�.��W���u� i����v8���h^j�o 2�g�"I�-����@f����\'%ƞP�n4�(pJ����&��!�uX�j���i?��o�3����3�P�bvP�O;[6��#4���8�Z?ϗ�g擎I�����w�GJMnU�n����K���u�ώZ�Z�;	b��fF	-�Ҭ��vr=�5ѵ7��f�zq^ ��1P_��MU0�L@z�y� h�ZBl���8Gc�4�Ϧ'�rP�f6�}l������9d�:�bA{�J��}I�qs洪*���=�5ѵ͂@�u�7ifE�����ԛ��Z[��n�]!i�����`�iJÀ� .��78�-�K� �m�^5(�M�M�Y��G�Λ�%����ݚ�:�P�����X@�w��=��S�� �D�B�AŤ�Ud�q;s��B��i Ф}�#P�j�eE�$��#M#R���4ճ�QMo&��#s-0Z.F�shxU�D��i�vO^%�v@�\wt҃mV[�<�vzu�BC�Ug��̐�b�Ou���ׂ��l�>����|��pַgl�*l����Fצ���W\ai�[F�@�+~�Y"i\�MCv�͈W�X:r,5_l��7zh+��KC�Ji��^���z��Ʈ/�G��Y���삋����C+���mt���6���*��{��Ȥ�0U��i�(=η�OE4�����[��
���I֡���?@�a��aG^ms*��BhY�z�~���;/2I�_c��ѽ�.�j����,0mY��� ��1��U8�(�)��Ρ]�G���ى:{�^��B��0 �"\J�hq�	a��:�����E�n`Q>]���>^'>D=~Y��{@�U6�gB�����D?{�*��5A��oIz�	�t�	��5\꺝+�w����-?�@������z����?DѨ��]�nM����})���B(O�|��Cu��k�G��Z�=C�����g>Fj�qh��A����[؅T�3�a:�L�$j�Ya����!������P�7�v=�5���(�jf��D�L�?�����Pz/�iFq'�+Qk�Z/�Co䚉�����4�*I#�{�*&!�R���F[�FN�u��D$�9�}�e;e.g*���[ntU����ҙ�遼0?M�N�^6s�V���i9G]�o�-y����d{Pj5V9G�į���RG\�D���)F̥�1����/���rT��wG�x���iƥ���3XuT5�WO�(\гa�"�TMS���@��sͮHQ�I�!�銳eƥ�b���>��E��,�<�ʆXkVM�-3���O��OG�6��D	��ἆ�_�-��2�ܩ���YU�>*��ĳ�a�rw��k)Zӓ���6��Y�AgԵ������p�|���l��_�H�޿�S�^�}:�E�K���|�b��UY�=�V��M]Y��p��A*f�ӟ��8�UU���!�h���*i���4���9�����^�I//cA�=�Ԣ�\jׯB����"�k��Ev	���.�6���I�R#3	kN�����M��nH1�zZ+.�TV;L��R+���q�KJ/��65*�[��V2߬��+���Fף{] �-Y.	K�hQ��Y����nL�g�+Ӌ7U�=�R��2�!SN�䯨^���_��a�Z	��Q�i�]!��6Z���T�g��sp�y�b]|�����F�jD�� �I]Q*"&��*���x�5<q`��@���ܪQ/��r�-q
pk��B{���M�3̶�EWor��I�X��T\���ۨjY�u�7�}=���%�����Uh �Z�sY�{�;�D@D�l-����}���wT�'�c����EVK>l��֪��z�ڀ��ƾU��t�� 7��#!sOCv��`C�*g?����#��`
���V�Je�4fS����Ԥ�H��j�kpԮ����fhme�%�J��꾟�vyi��qR������b5����ȟ����*_uȧ�{]n U��1�F�M]����S�6!H%�)�VԜ~�}�?[Z�x��U�h����ք0��Pu��5�0��5p-KS����b��Y� F��H2����mt]�HrVq@{�-��a��/�[Җ�4U��.Y�_��<��7�����ݕ���Y�?�*j�R�f���':c:OJq�k�����뒫��{]� ��|]U��굧ۯJ�2�>v�U�p,��R�H��*�Y䧩Mߚ���_�]W=�i�8)3��=�G��! ���N�lt��;���UѶ���,ɐuT'���dU����[V/����lC��:|�X����tt-{jz4Q�y�L���� �b�ncg-w�$��t�����4'�wto���s�*ۀ���~�Fx���d�k.�jR��13jF�h��SP�&�#���MW�1!Fb"�X�����:�15��r��fD�{��0���+��EY�G�۬�ӝ5�z-;�<�~=��A��6�|Ŋ^��g0h��'�Z�g�o�LQ��A2��F�i,?"�5�Zz����w4,��!I��#��J|A�~wto��u�"D�Z8��E��x,����MHa��Ǔe2bq;��W�.˫rM�����ʠ�QZ"7�_����G���\⹹���N���"֗��&����³A����E�����)�dk-)T�Q�M>�}k���<���X�q�?��٩0 S��������Tڏ��Zwi�қ���Q:�9�rm/z?��ѵ�Qs�uɡV�M��9\sxSNjW\aR���`��m�&�yTmqp}��*����~�_�"�
���	�~Ÿ�b���"�"�W���7?����Z�F�2�5�W��6XF<�^Z���.�ui*����u>k�͡�Ѹ����0+���U�g�����U��5�
�U��p���IO�Q�����_ojߏ�mt��7��P�9��H�Sl�jV(J� ��G��A����;IϏ%�󶿘�k�^�}j�A��eXaCF����j�?d�y��N�j���{]E�Ҿa$��HB{��h4�5bި�ʩY�.�fyMs�ԣ�l�1aؠ��`��a�*�*��~�)l���Iz�|�%s���!B}9���    �!�G�6���S8]
z�n3t�X�xF��5�w(���x�P页�|#u�/.�P�a�y��#���=�ؖQ'����T�Ѹ���G���!�P|C��Fף{]x6�c��D���v�.QKu���"������!Pε|�P�#�dĠ'0���`�-"OpL�4��C�&F+��� ���㹿�ي`��zto��4�ѥ2�6��g@�U5@���)t����>��=�_.��rƭc��5��&æ97��|�B˼s�u�^�+�Z"�i����B+��"E5Pݚ�r����F�%�N�R�k��f�vj�\+q�1�ᙋ�IC{#�v�i羋:���t��`�n��^,����^�J������N+�+JSj�sl?Q��3�P�������FW��47N�4�aVvh�K�K+v!5��(�������Y��м�%�¥��N]{8����V�1�a����ń����Ͻ���!�Td�׮G�6��쬡��VN�;�Ov$l5e�����4'WR"袯�� �TuHmGt�@��ŰM�ݫ(W�C�1����Jm!X�C)ǩ˪�|Q���X��I����G�6��l����5���i��Zq�T3M���y�K�3]iKE������=2�]����k�0��qx?��gP�i�営iƉ�����ғcWNC���h�_�F>���ڍEN���fz�(��b�v@��x_woK�T�z�fG��z��<��n0��%Vˏ����_��m�!����E9�z��j��m���w_!�zro�k=���HĽ���	y��e�Hі'�Ό��Z+W�뺟/dp����v��}�Z�}�h�^G��12`���X4A��:��^�4�>����yymj�zS����F��ؿ5���U�O��U�G&�5G��E=X���e�G���$a-l����Q`�8����ǦE` ΀r������k�9yfD�~�Hh�����}p��>���:��!�uS��%@ĆKie�FκB�����S@�F74�(@ZU��`�ȉc�gἬ�ڹV0��[ixX�>r�����p���ټ�����F�Ų+ Ԋ�2���+�ܩM[���B������j��h�m���9���d�_俈&3�T���_�5\S��(u5��efS����a��y�A�d���OG�6�������d���ADMҏ.6�X��\K�I�4��^/��s�&v6$2Y��� a_ʩ����(2#��"Ҫ������8����K��G��nmt�2�C+�
�6��������H� 7,�P�����X�������� ˻�;qoM	�cJ�6t�G`w풘I|"�{�3���hE��nb��h?����4c��S�_��\�_lm�3� ڀ�,�tߴwE�$ MY��W�9
3�̩�bvKN��5�,w4Y� ���c~h簪jdkg��y��@��ѽ��K���J-�<r�Lm=1Z�������k��:zJ0�sM��[�n�Z4js���cTˉ�C/$���h�*F�LP35F[�\����J����rpo��B��d��p�L�g_�j֣�Z������C�������6��Uͳ���V��;wM�$��a��>���m֎�hb�B����ĥ)V__�>���:3CK�:�ƹ[ȫ �h�� ������6��c��jn�s�����Z?u�/ѭ�
/Аhy��'��5&D���H�\F���Q��B}���=7��-�E,1j53��Wc����'B��aYm�=+Kb2mT�����:�Q������HM+�O��d�Xx4>?2��)V֔y)��p��M��Do2�zt��?��E�#�H�k&����?d�l�$�O�0y�	�ϩ⩂�	��@��*d[ "P�'~�W�3�\�]����)�������4�VU(΢^���mt����5�s�M^w�"C�j�n�A�ǧ�D�Y�;��rɑ�Uv�p�j8닷�TQ+����P�	�9,��FI���b(�=|��Ć`/�i��ѽ�.yߤU���h0Hr���gC$k�ȟ1|��f�^�q
�&i,��|N����'�^mռ�3y�tu�J3�:��r�' �̳�vݎ��/Z��
H�c_��mtmZ�����H�Q���ۦ=���pm�5�Ɇ�y��-��To�a�2�����t�OG�s"`�V����Z�ԈL�CD�q����"5�^�>���:�e���D�6�C@;%M��=X�2�8�H�T
�@�0"�=h0|,T�S)r־�"�0a�A%��Y���N
S3��������!k�ñ͹h�*%|wt�C.��&�`v����iZHC��m�\���]���[�z�su!����r�@�S��p,���s��i@݂F��٦�cm�ӚLC�Xy���#��0�B@���|:��хc;��iki�q2��!�2�
�)�_o��RV�kUK	����t�
����;��KC�;�%&[\Z��~�����M����^Zzp2����t����OG�6��2C��l��n��V4�-3+),����&ߑ(��}G=�U]Mk�w�qTHB��SO����9�U3ҷ�A*��)��Z���2���g_��y��E�����A��"�R��9�<��%�9���MU�xm�*��m2n�4{R��%���Ez�� ����ʩ�d��nj���6
ZX� �<�zto��=��yV�jl�f����A��G�-zG#r��G��D\	K�����9�����f���J�,��\B��J��X	�\>���U~�"6��(�/��ϣ{]��W����4��
�ӹ�Ia�����1�֙�R�U>{��?�Н�*C#��l���%�VdT~����a���S�~�Lc�7����$�u	�Wz폣{�vմ������X�T"������q0˕n��Ƿ����l���bCxh��Gݶ�k�j|8����Z{M��Q#��6�E�6�Ú6�+f��}ţOG�~t�"��v�6��ٹ��2�F���z���MwZ�l~��D��#�n���Ҧ6�n�ѡ?	�R	��>���>y��5�I"�=�G�{�z�ף{]t���%�4�0HO����mGo�0��א��h[]YY�B��,HF�OH/N_���{�x��]�$^�=�\*�F�թ6I҃n��x�nD�W|��]��y���bC�Z�Z��k�uT,��ՌcT/X�R���R��M!Q<a(9 y��sYgQ5yhr��54$?Xh���׷ǃ+��e�*�Wz폣{]�(�5��C������^��𗀿\|b�گ�wG���S[�5�ad4��93|<�C��<�ߩ���l������b�*Ԟ�\�ץ����j��]��9�5��9�;[4jVt���wz�G�;��5U�7_�n�1y�� R���F��lժ�2Tﶣ���?NM3��F�ik�0RL�S�����7�}9���ŋ���̺~�C{�^���_|��Y�	�i��k��������}�d�ÃV�������>m]���U[���Ӫxq�����_�e�� ��W�OG��v����	�Ρ�f4����}�P�2�K�����WkUSo,;F�ٰ�F���t�B
�z?�_��O��j���>�f����^�����_���G�~t��Uͦ�^,����a7��!K�,s9㵋���NV�m��?;��ʠ��K� ��*�����Iei�4�U�]�E��#�����Ռ�j�[y����B�I���뽵Df�+��:���iʬV˸����zQf�{>5�}��[yl�ޥ���k�Q��2�) �V��k��,1ys��
O�Y�v���*!.�����M���"��A)�[���_�*��z�qsg�y�FN���9z�l���^m�:h0!ց5��h�mkҾ-��=���^�]|��5���m�zto������&��CH�2�=��s ~V�<��篈]ݛ9�q�1�����b��ϨL����3�k�ւOά9�m�r��UG�"¥�_��y��\�W*��/��~����j��c�v~��͂K�1�9Tg�vVD��NFsC��1�| j  L�Z��1��ƢЇ�����y�h~MP!3���T�6�Z���O�4Җs/����!��nmt]�j+U�ͪ�g+����I��Va9��蝩��a pF�:GЎ�.gs�Z�TMZ�4���Q{K���nM� G�5sF��	#��E�&�%L�|wto���=��ϬWI���Ѧik#���n �	��PmP)uTioz_5H�Dڼi������.	�a��$Sk���v1��%�ͣ�Q�8/�������G�6�NA����
�rm{=_5�9��d��5�0��W��$޳*/���X,����xL��J�B�S�m�S��-?'i�t���+/��O���{]+���,�V��'m/���j��>�C\-:?v�uȹ��N�
X5�X�D;�����느H��t���*��s�|���G;�e�ӱ".~wto��{��c��4:�"�NA�bC$�X��*�im�.�	',mR)�U�@��k��F1��?b���*���qZ�z�u]������9������:���qy����/㿨�T7�ek�j^iQC�_ܨ[o��s�~��	�`42r��M���;n]d��4G*�B:Qe���eM����Oc���2hV�]��mt�G�F4��kꚗ�T<��*�^��>��nl�$x2D��Hcεco`�ڹ0�,I����V��շ#�i9h�_���L���..��!b~��1������F5k���lCp���2���k�Ө�v�@��Y�ך"�-Tx&���ˊZ�5U,�ԇMB뱡����k����0�κRB�hNKv�����!�9�7�~o�v=��ѧ5��Qw�z*�>J�g-A�$m߇����@Ԝr���|n�� �r�LTl�Zw �qi�c.C}��59!�`�g#������>=�f���P6|��zto����⣇����պ��r�f���*X��f��\R��ʱ��K�<�%�� Mf��\���;Y��� ��:�J�Zk��1*#����(��^(I�Y�~=��Q�<ɏ�`׹�[%����ZB�gR����O�g!(�&��K�F�lY���K}��g�f�2�̣�@xBѱ��Ğ������0a^US_���ѽ�.<���J�\"��E��t���%�α!�5�PKwb�����em�d9_c�*()E�/�cF���jZ=�����Q���v�Oދ�0�Ӆ~N�+}:�����("5gY���5�����[�<�|;�����)3�?ׁ>�+��R����j@�90k�?"*����4<� o{���w#?��v��"��ѽ�.<��˜4�?dƤ��D؀�ү�v5N?B�xB;��=-a㼏�ȐGu U��>M��o�
�X*:�`���Z�� ����l~�;T��gA�'C������F�u깘��2��<��*�\�6d֤Uk�m��q>�IQd����w=:��>�H��?�9V����倉��>W���|�Ƈ5����8���G�6����δ��h�\!�WA�	�O$�0�ɻ�Q�GwA���#��[ ?�SM#!�'�ju�s%"����y-�h�z��򸍢'y����{]x�qK2tw}�}H��A�Di�-����8Z�DF�Co=�z��tt�&Fm3&��
�&L�F��[kg�E;W� !]�h���?k#�ƴh}�������F�z�?f�CB!z�1w�k����0�4�b<�4�WW(�h���s�#�E&3�x.�s�Y�@�VG�b7I�H$<����@=��%�"�iy������ϣ{]xvS� i���v��VU��D4LuO�|_x�P��P��4k���k�oN6J캺F��k�h�~�����N�N󵽞�vxޏ�����i?���³���
25&��h�u��bvՓ!�$
VvEM-,�!<r�P�̇�@���5�܎�UM\S���D�Z�4�N�oD�{�$P�q��Bd��Ə�G�6��7n34L���d��ζ#���Q�wj�Mk�4�L
;V@� '�cyh���k�Sϳj����E�}	@T��h�=�G����*_u���;��r#�&�E�gu"�#Q�d���w��h�kF�H�f�,�e���#�-f9��hP�H�mlrK���P���z���zB��ѩ�2��W�����v=���E�x (O�y�a$�RUi�����;w��M��@��JP��r��?�m#U���HH��(��<�Ku�3�r�h�b
��Րxzv�m>��c֥���o~t=����^�E}�pd��&8�!�׭�쑉�IKݰC����d���5����>P'�RgnW��
Q^��9�cA�� ���=�
��KB͛]��mt�*��9�֪U�	�d%s����Z �ZxKi�4��936w�#�� ���l���w�*��4<ܹ�*!n�V$��mVX���k�	R��wG�6��5�4���NS�z�Y����d�2���qV���� g���K���)��MvZ�v�k���	F�$ѮVo]#�J��7H��yi:���ף{]t?I*�Н��E�Y	~bg�@w� �F!�k���9ׁ�sj?
*�G�@Ϋ�R�������V�C�}�]������Ә$8�G�ݏ�G�6�4U�AfTl��^���VtOs�U=�o��w����@�ע,�P���ǭ

M�������OA�7~6+�6����z����c-x�WN�����>���;m�j�F�Ǝ0�����aި�[�U�Ֆci0�RBy��3�c[���sΡ�]����&1'�1�.����G<2�k�d�U;ٞ���"�d��v�����F����HE���ی���A��h�HȰ�`M�:����lꏨV�&]�Om��
�U��$i��N�.Iu�Q;>���!Α�������>�.6"�:ӊ4g�-R�i�lK��n�Z��it]fX�������JI:�'I��˩��.n�٣�*bMao��e�ȹ��G�@y�I^C8������ޏ.����14]�"F ���꼎Yz�Z�H[�n�JQ+��Y�&�g�G�����E�� ��A�Ԇ�䚖kb�K`��@��k"(=�������ދ.7l��fP#��z5b5B$���eu�+z�n��L2���dv�t�E+��m�r�����	���V�!�"7��!��,�Q��|܋�yY�y��ѽ�.�G�Ļ������X5Z>TQ/~.��'�>b�Y״���Pk�%M�֜�����t��t����(4�x��
�4���ؙ�|�i���*��qto��푪;��B7I�i�ZY+����+�{(2��w`D���M����  8�ZпC3 E��c�dڦ�n�|o��å��|�A����%}�;����_�ӟ�Jp��      �      x������ � �      �      x������ � �      �      x������ � �      �   �  x�U�[��0D��bF<m����:�p\N��n�t\@ALt��s������墩�N����|q�M����
'�[>?)����=�+��	�7r�?7�C
�]�T��E:��Oմ�,�O���\�s8<cS]*��eC3��P�{S<�E����#�e�� �l.'�SUd`̰A��!N,5Ym"��sX%t�)Nl�É�ųSX`���v��7���#..G��͒�ŕ�O���qӼ��͋�u�G�մ�|jmCa�C����߃�o�zJ�ZQ>/B	��~��EǓ�F����\���َ}Rh�n0#A�i9��+���з������#��;G���-������0��F����`�u#�(�#)'#Go�4a���A�>��oF�����A�cs�E���h��,읺�V�$�=�Ԍ�I� ���y�BnGS�"�/cd�-gSzn5RfoB�]3�� $�[�3\o��D>l��c�Ş�[�^�ױ=��� <��X��B]�'%�g�����G��83�������c�+qh�W/����ȵ'h���S����C�Z|�[�����P�2X@iĩ��b(8ǲh�^���{��q��-��#�"�'c��u�{ђD����nG����T9��`��A�@���l���xF�|���������{��LJ��l*�^׍�{�Ut�-�O�bHw�e�ڔ�;z�W}��0�Y���nw�Ze��/���8��ګ�v������*K��      �     x�Ֆ[�G��g�<z!nե��z�Bn8�<8�y0��bae�h���ק'�ڈ{��9���T���!s���K�9���4��Tp���s��#��i6V�g�&]����vq��Ϯb�^��o߽������?z5�:"�Ez+��77�����ۻ�coX�g/����/���}�����r���a�[݈5`���_�ۇ�$�E08��Û/��BQ��D+��cr���Sʧ �`T4X]��3�Az1~�\0py�������7�Cm�?6�xrx{x7�������2�R�$����T�'�`�Jp+��)��5�|�>����v�A�t���'t�]�!�$UQU2Tb���s�YJ��"�(���+�W�O�~2ӱ�,m>R���Ð$��)��N�Dn�:�ܡ&�OH�� ��"Jkҧ����Poo74����4����|w�m���'��@���0��X �Y�-QH�� �$h��E�;)QwYz��I��	�Gph�y	Ds��[�������-��=�Im0�"k���Gh�V����$���M|KV
F��ۧ�}��	�uk����&� H�c _r��V�b9ո$u�v%��פ30�M�7s���G`L���8$K�Wu��SR?A�~��E.�(g`�c,��g�[��Zj�� Ԙk.L�a����g����`cQ.��O�u r$%���R �%��@�,�Ig`�c,��؎*0��"�A�fpΐ-.�� M ��x������C�Ƌ�����yTqꩄ��eNKP�����h�S�Lx�7����oդv       �      x������ � �      �      x������ � �      �   g   x�}���0Dѳ�b�50�kI�u�����/�hc��Q�;8�4/إ�֘˵a�!�=VĬ}��gY����졟��c��z?h,�؃�$w�/�+�      �   �  x��[�rG}�Bo��V�.z2^�e�66�p�C�Fh�4�52���5uMg�hԄ�H��9YYy�j�$�w�	�&Wm�����zq~v}�X���;����.O�.nf�e{����I2`���x����S�S�'uKP,��o�7_�7Y���'������^?��(�g�H��+lb�_�D�q�&Z��18������dɰk8 ���l��%K)`�8�h�
hG��n��
є�8��=X*l�q�y_�(5�1K����S�1D;p%���FS1��� MoirF�Q� �
�8��\�&��,QI�o]r��فka�ࠒ����%"-��H�O8*B;p��I�H��5y�d1D4Y�Q�+��C���tF_͢�$.�`v����D�i�C�זX�	��Ԩ�&|�{��ʄ�)�=��Z�����֍S7���ꄺy�x��*�(�$�T�l�ǩ�<!�gП8&T0T꓄����J�ʦ��@�j1H�aLgR���G��\I�٤��A��B!EUJ0���O�k4?�h��ʤ!>���FiZc���cv�7eMM���ki�5X��V)�y�Ώ�RL�R>��5w��'����)�{n��:0�l�|D�Dm��&��`��RaL�8�q�ځ�T*�rτU�j��d���TJ':f��l�����`�
k��&�3�JE��F�3��`4�ʟ�kt4`��0ܤ��T�I'�q^��hʑ�F[���4�L�i�O|�T��~T(�X�CG���&���*�R����%3�`�$p��5��Ƈ[����J44�j��6�]����d�MA'����Z�>�k�qc�U��*�|6!��A{U�*���jE�D1W�T;0�\���L��&t����j��Ft�C�c�Z!����M�M��a��ZQҮ(:t��ځ�R�0g �ڶ�UpçhԫV�S(�c0�q���X�qv�˵��^_/����=f���P�~mҌ���N(�-�!�Y�9->����f-�h�}����JZB?�7&���:��Ү�|�^kY���K��ڹ7�?���@�R��������=B�˰2!F��ĺ�(��ݪ�F	��h��t����v�������Y�NUR�i7Ӌ����O���>��_���w|���C_���Tf�&�Ѡ}����}�Iu�gٟ��������v��7ɷ.������O���|��"
Y�R�H�|lL"�wz�N�|1!��e-���Y��Z/n�~�Z���^�?^�?o?=������������b������x����?◛�tu��?}'����"����$��6�Q?C�]/�۽���M8��kvs�N/���0�ܫ��Ͽ~z_O�Ż��}��_��K���K��TMd�l1�so������.ѽ]�X�_��fN��_~:����_Z��D�ҟF6��mJ�n�,��!3��8&����\5�Gwg����䮠����;�+S���7�����%_8�q��S�Ao����b�W�����w/��|�cv��������;Ei�~�hcm��mV��խD��8f�vн�|X�����_?�{�����ի��|���7.j�oƵ	ȥ��x�yB�/�;�����rwн�{7k��ӳ�{%�r�t������Z.o�����o�.	B
�rmcݝ~W�C��v`M%��~����.f�����f�\�}����� ���1�>f縈�He��z���cS>Jt{5[���B;�;�/��_+$S#����6y<dg.ǒ�J�M\� ����������]�������2g���vzvqT�t��)K>5@�(\5��*�CI<�m�%!p|�_��}�h١6�L�	sa��ŔuI��5:h+#��z�B�1R�Q`�2�r%���>�-�y���9P�6ŀ��k���WQ	vE�sy^��'��d����w��Ӫ2
l_F%pXr����5�D����:�@�}仝2:l_��\�5�9ae5�ɋ
�X(#�caj���}� Z��I*�&�(_�N����9�6#�?>Öؾ����O7���Y��)�x&�A������.���e$�\��g�jm"}O���Ή&hQ6J��w�BV_� f��M��`'�C��<��訐E�$�;�&�|�`]t���Ne�(���H �t�M!*�u�a:�|���?�UuX���tZ]k�W7���0�.:PG��L,h�utX�Ôr%�cq��M,��X��@A�t���/��::��Qq:C#�|-䲉��}^��0�5�����uX��R#��{�S�4#wy�pс:�!���}n�5:L5������q%��)�c=t�m��%����FF���4�H���	uk�o��C�H��R�V���<5�XuJ���H�X��u���?�c/�f
4�<�ʻHlv��D1���[��@S�-��{�kt��Q��2ϱ��+j��T�u$r�G4���0�5�C��T�	��	�����p�a:�a������kt�M��N����M��pс:�4-D��qq]G�5:*��؈���T��}�-t�
��1��������FE����A�6�+�6S���u��:����-k��Ǿ��>9;og_f��II��,�����ĺI\X�Lo$�w �f���wq覟d}۽��U���P~����F삇��4�G�=��7j?�
��iVePJnWA��G����6��yl��омA�1i����3�^��g�"w�>mV�1�bZ�}mb�hg���v��-.�س���dA\k�V� A���{�F�/s�w�&��~���yS/�=��7@t��P�I���s�cM����+�&�;S�L�*��M��i]}M�����m[��Bg��b8�(���릨���5!�k��NYf5���<�E�xH��]Җ�V�@�G����R;�J9��|�5O�<�?�.S      �      x������ � �      �   >  x�}�Kv7D��*����!m#�L2���?ED���ݤ'�q�Wl��G��G���ܺ��?����>������6~��j�%����}'��h�|B~�!�k�8����&T
�x8�x,�J��x��K�P-(7gocm��h�-iB���ݨ�*��>AK��^P	�˰5T�$�p�/iB��M�xs��jމw҄��Z  (h�S?L:�}'Mh�I,l�3��͈m'Mh���g�)-��U���*%���!���e�ƈpDwRR�R��+iﺦ��uO7���Z�b�>�F��%Վ����U�������kzs�~�P��NJj���f>|�T�û������XEF3Yz�0�ߩW)��+6Q���*����q�֫��2c�����XX*���i�*%���>z�0[E���ڽ\�� �,�a}w�~h|�NJjyK��vZ� �B���UJjyK���tl�jt ��=��KJ�����ʺ�kk(����ث���0*�p��@����i�%%��%��Y�A,�É=��ZRR�[��@b ɮ�W�OԒ�Z���W����H��c줤�����6�f�q�`>�k)�,g!���R�drC�������l��YHV���;�y��㖳�RR�wh2f���Xt�f_�̎fq'���O�ڑ�ޒ�]	�A�@��r�Rԁ��eQ��t~&:;���ޤܫ~SE�Ek(1��d�-Z���T;���v�E`)�T�m�W)����4�e*{�fs�h�[�}���'���0�En�j|����YoRR�I�$伈W,�g�g⸝�UJj�T��ah_�Ti�P�U�7iR���6��h�Xī��A�a�wꛔ��[�=�#`{�RR�f�����[���E�.�h��5�-�II=��4�ےn}EmY�+�{�~�~M�ò����8?|?׫���[��fw$�չ��������'�E�,v���/�Y�x&6�I??�S����5��\��}X줤��:`8��{�}.CmB�6vRR��HY�g���b�F�kP�d�LT�6� �;�Z��k�;)������f����}>El��rQ1(�h�ߣ�����HI�o*��$﫸B��1wy6�RR���T���r.E��ߍyb'%�N*b�d�X
�����UJj/*�fx�5�	�2��%%Ջ:0�f��~�����UJ��,L�C,��{%8�����B���E���s��31�'jI�ک�p�N��'�s���d�1�zzk�Z�9­�v ��EI&#<�$�U��Ӕ} Jn��*%��%HUL�cC�i����%%���`E3dD��7&�-�NJj9���	T�V�l�n�*%���:b���XX���s�JI-g!�nh��|��@7}������19ͱf�Ę����RR�W����з�K�1�ː[�J���+�y�-�ε��� ��.p��Z���-���a�:��=�NJj9�� c�9~Mu4<��'𒒚�2\�p��?�o�Ӥ��L�8�|'����zRc�st�{I���{����RR훊tE�m�~�Td%u���| �E���|}]�u>X���d�ɜO��*�O9`�DkF�|��I�������XfE�      �      x������ � �      �      x������ � �      �   �  x�}�]s�@���W��[�s��e���Ml�[tdrF+�B����ѩ�kvg����}�g�X�כ/�x�/��k� P5�6кМWo	C*L<,)�-b	EAu���v�i�J<�罹םt1�M�����٭��J�1|]���d�z}fz�x�n���G	�/�����{O3�L��|Vx����m��x��R��	�(�gp��o�ڳ�������������.�UWhi`-�*��S$���R�Hw@ӟY����a�~�ΖQ��X�M���\���W��f�e����k���>3��!�������}4C�,"���'Ag�Z!%(�J���?���,�?���&��S)�Ҍ�Tr���e�ڞ;Jm�����p����hh�T{�O�wg���	�߉�qq���L$B����)zF�`�%��O�U�Y�$Qr|S/û{�Mo��>���0�9&�<�t����j��+��      �      x������ � �      �     x��KO�0���@9�Ռ_�s�P�r�������fc6�h���o*� NH�4��>'�σ[�*�.�b���0Ɲ��W��>V�T'yY�uuv��Ϧ`����7�C<�.��iu�LE.��[U����U�ZO�6���ⰺ�R�|~�J�;�C��w��G-c?!n�}��Q�؇�b
���r����U������?����S�������jw��mq��ک��r0�TG�<�I(�����7d�h�T�Oi���E�z���ؿ�I���2�&���\�!�:�vX��9���/{�����w@gQ!Ԓ�"ɤ5�9�5�H���@��s����l�m�n�Ϲ�B��R8�ʾey�I9FB�,e9X�-RT��%ʒʂ�̨
Gs.)V'@+%���R��!ai�A���+�3ܡ2^Ke����F���F��>L�ć��GY��+W���yf��(9W&��	І�ey  uML�"�ӱx�,��LܼN�D)�D,�2�%��J�F�(��=���h�l��+]��ϥ���|6��Ʌ��     